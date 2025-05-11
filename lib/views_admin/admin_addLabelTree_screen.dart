import 'dart:io';
import 'package:my_flutter_app/provider/label_tree_provider.dart';

import '../cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/service/label_tree_service.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';
import 'package:my_flutter_app/service/tree_service.dart';
import 'package:my_flutter_app/models/TreeModel.dart';
import 'package:my_flutter_app/models/LabelTreeModel.dart';

class AdminAddLabelTreeScreen extends StatefulWidget {
  const AdminAddLabelTreeScreen({super.key});

  @override
  State<AdminAddLabelTreeScreen> createState() => _AdminAddLabelTreeScreenState();
}

class _AdminAddLabelTreeScreenState extends State<AdminAddLabelTreeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _diseaseNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File>? _imageFiles = [];
  String? _selectedTreeId;
  List<TreeModel> _trees = [];

  @override
  void initState() {
    super.initState();
    _fetchTrees();
  }

  Future<void> _fetchTrees() async {
    try {
      List<TreeModel> trees = await TreeService().getTrees();
      setState(() {
        _trees = trees;
      });
    } catch (e) {
      ToastUtils.showErrorToast("Lỗi khi tải danh sách cây.");
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _imageFiles = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTreeId == null || _selectedTreeId!.isEmpty) {
        ToastUtils.showErrorToast("Vui lòng chọn loại cây.");
        return;
      }
      if (_imageFiles == null || _imageFiles!.isEmpty) {
        ToastUtils.showErrorToast("Vui lòng chọn ảnh minh họa.");
        return;
      }

      final diseaseName = _diseaseNameController.text.trim();
      final description = _descriptionController.text.trim();

      try {
        List<String> imageUrls = await uploadImagesToCloudinary(_imageFiles!);

        LabelTreeModel labelTree = LabelTreeModel(
          id: '',
          name: diseaseName,
          description: description,
          imageUrls: imageUrls,
          categoryId: _selectedTreeId!,
          createdAt: DateTime.now(),
        );

        await LabelTreeProvider().addLabelTree(labelTree);

        ToastUtils.showSuccessToast("Thêm loại nhãn thành công.");

        _formKey.currentState!.reset();
        _diseaseNameController.clear();
        _descriptionController.clear();
        setState(() {
          _imageFiles = [];
          _selectedTreeId = null;
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
                      "Thêm loại nhãn của cây",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                const Divider(color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  "Hãy thêm nhãn cho cây trồng của bạn.",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),

                _trees.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  value: _selectedTreeId,
                  onChanged: (value) {
                    setState(() {
                      _selectedTreeId = value;
                    });
                  },
                  dropdownColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                    labelText: 'Chọn loại cây',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  items: _trees.map((tree) {
                    return DropdownMenuItem<String>(
                      value: tree.id,
                      child: Text(
                        tree.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Vui lòng chọn loại cây' : null,
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: _diseaseNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Tên nhãn',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên nhãn' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả nhãn',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập mô tả nhãn' : null,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.image_outlined, size: 28),
                      label: const Text(
                        "Chọn ảnh minh họa cho nhãn",
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
                    if (_imageFiles != null && _imageFiles!.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imageFiles!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                    _imageFiles![index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      child: const Text(
                        "Thêm loại nhãn cây trồng",
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
