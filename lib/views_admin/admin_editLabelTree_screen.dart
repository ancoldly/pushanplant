import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/models/LabelTreeModel.dart';
import 'package:my_flutter_app/models/TreeModel.dart';
import 'package:my_flutter_app/provider/label_tree_provider.dart';
import 'package:my_flutter_app/service/label_tree_service.dart';
import 'package:my_flutter_app/service/tree_service.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';
import 'package:my_flutter_app/cloudinary/cloudinary.dart';
import 'package:provider/provider.dart';

// ... (imports giữ nguyên)

class AdminEditLabelTreeScreen extends StatefulWidget {
  final LabelTreeModel labelTree;

  const AdminEditLabelTreeScreen({super.key, required this.labelTree});

  @override
  State<AdminEditLabelTreeScreen> createState() => _AdminEditLabelTreeScreenState();
}

class _AdminEditLabelTreeScreenState extends State<AdminEditLabelTreeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<File> _newImageFiles = [];
  List<String> _existingImageUrls = [];
  String? _selectedTreeId;
  List<TreeModel> _trees = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.labelTree.name;
    _descriptionController.text = widget.labelTree.description ?? '';
    _existingImageUrls = List.from(widget.labelTree.imageUrls as Iterable);
    _selectedTreeId = widget.labelTree.categoryId;

    _fetchTrees();
  }

  Future<void> _fetchTrees() async {
    try {
      final trees = await TreeService().getTrees();
      setState(() => _trees = trees);
    } catch (e) {
      ToastUtils.showErrorToast("Lỗi khi tải danh sách cây.");
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _newImageFiles = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  Future<List<String>> _uploadImages(List<File> files) async {
    try {
      return await uploadImagesToCloudinary(files);
    } catch (e) {
      throw Exception("Upload thất bại: $e");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTreeId == null) {
        ToastUtils.showErrorToast("Vui lòng chọn loại cây.");
        return;
      }

      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      try {
        List<String> uploadedUrls = _newImageFiles.isNotEmpty
            ? await _uploadImages(_newImageFiles)
            : _existingImageUrls;

        LabelTreeModel updatedLabel = LabelTreeModel(
          id: widget.labelTree.id,
          name: name,
          description: description,
          imageUrls: uploadedUrls,
          categoryId: _selectedTreeId!,
          createdAt: widget.labelTree.createdAt,
        );

        if (mounted) {
          await Provider.of<LabelTreeProvider>(context, listen: false).editLabelTree(updatedLabel);
        }

        ToastUtils.showSuccessToast("Cập nhật nhãn thành công.");
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ToastUtils.showErrorToast("Cập nhật thất bại.");
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text("Chỉnh sửa thông tin nhãn", style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
                const Divider(color: Colors.white),
                const SizedBox(height: 20),

                _trees.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  value: _selectedTreeId,
                  onChanged: (val) => setState(() => _selectedTreeId = val),
                  dropdownColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                    labelText: "Chọn loại cây",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  items: _trees.map((tree) {
                    return DropdownMenuItem(
                      value: tree.id,
                      child: Text(tree.name, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Bắt buộc chọn loại cây' : null,
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Tên nhãn',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập tên nhãn' : null,
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
                  validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập mô tả' : null,
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
                    if (_newImageFiles.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _newImageFiles.length,
                          itemBuilder: (_, i) => Padding(
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
                                child: Image.file(_newImageFiles[i], fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _existingImageUrls.length,
                          itemBuilder: (_, i) => Padding(
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
                                child: Image.network(_existingImageUrls[i], fit: BoxFit.cover),
                              ),
                            ),
                          ),
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
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: const Text("Cập nhật nhãn cây trồng", style: TextStyle(color: Colors.white, fontSize: 18)),
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

