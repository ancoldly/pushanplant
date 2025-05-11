import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/models/PostSocialModel.dart';
import 'package:my_flutter_app/models/TreeModel.dart';
import 'package:my_flutter_app/provider/post_social_provider.dart';
import 'package:my_flutter_app/service/post_social_service.dart';
import 'package:my_flutter_app/service/tree_service.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';
import 'package:provider/provider.dart';

import '../auth/user_provider.dart';

class AddPostSocialScreen extends StatefulWidget {
  const AddPostSocialScreen({super.key});

  @override
  State<AddPostSocialScreen> createState() => _AddPostSocialScreenState();
}

class _AddPostSocialScreenState extends State<AddPostSocialScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  List<File>? _imageFiles = [];
  String? _selectedTreeId;
  List<TreeModel> _trees = [];
  List<String> _tags = [];

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
        _imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitForm(UserProvider userProvider) async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTreeId == null || _selectedTreeId!.isEmpty) {
        ToastUtils.showErrorToast("Vui lòng chọn loại cây.");
        return;
      }
      if (_imageFiles == null || _imageFiles!.isEmpty) {
        ToastUtils.showErrorToast("Vui lòng chọn ít nhất một ảnh.");
        return;
      }

      try {
        List<String> imageUrls = await PostSocialService().uploadImagesToCloudinary(_imageFiles!);

        final newPost = PostSocialModel(
          id: '',
          idUser: userProvider.user!.uid,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          relatedTreeId: _selectedTreeId!,
          tags: _tags,
          imageUrls: imageUrls,
          createdAt: DateTime.now(),
        );
        if(mounted) {
          await Provider.of<PostSocialProvider>(context, listen: false).addPost(newPost);
        }
        ToastUtils.showSuccessToast("Đăng bài thành công!");

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ToastUtils.showErrorToast("Lỗi khi đăng bài: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                      "Tạo bài viết mới",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                const Divider(color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  "Chia sẻ bài viết về cây trồng hoặc bệnh cây.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),
                _trees.isEmpty
                    ? const CircularProgressIndicator()
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
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                  items: _trees.map((tree) {
                    return DropdownMenuItem<String>(
                      value: tree.id,
                      child: Text(tree.name,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  validator: (value) =>
                  value == null ? 'Vui lòng chọn loại cây' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề bài viết',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập tiêu đề'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nội dung bài viết',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập nội dung'
                      : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tagController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Nhập tag và nhấn dấu +',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addTag,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => _removeTag(tag),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.image_outlined),
                      label: const Text("Chọn ảnh minh họa cho bài viết"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white24),
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
                      onPressed: () {
                        _submitForm(userProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: const Text(
                        "Tạo bài viết cây trồng",
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
