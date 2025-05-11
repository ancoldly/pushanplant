import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/provider/tree_provider.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';
import '../cloudinary/cloudinary.dart';
import '../service/tree_service.dart';

class AdminAddCategoryScreen extends StatefulWidget {
  const AdminAddCategoryScreen({super.key});

  @override
  State<AdminAddCategoryScreen> createState() => _AdminAddCategoryScreenState();
}

class _AdminAddCategoryScreenState extends State<AdminAddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      final response = await cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'tree_images/',
      );

      return response.secureUrl;
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        ToastUtils.showErrorToast("Vui lòng chọn ảnh minh họa.");
        return;
      }

      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      try {
        String? imageUrl = await uploadImageToCloudinary(_imageFile!);

        await TreeProvider().addTree(name, description, imageUrl!);

        ToastUtils.showSuccessToast("Thêm loại cây thành công.");

        _formKey.currentState!.reset();
        _nameController.clear();
        _descriptionController.clear();
        setState(() {
          _imageFile = null;
        });
      } catch (e) {
        ToastUtils.showErrorToast("Có lỗi xảy ra khi tải ảnh lên Cloudinary.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Thêm loại cây trồng",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                const Divider(color: Colors.white),
                const SizedBox(height: 20),

                const Text(
                  "Hãy thêm loại cây trồng cho ứng dụng của bạn.",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Tên loại cây',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Vui lòng nhập tên' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Vui lòng nhập mô tả' : null,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image_outlined, size: 28),
                      label: const Text(
                        "Chọn ảnh minh họa cho cây trồng",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_imageFile != null)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      child: const Text(
                        "Thêm loại cây trồng",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
