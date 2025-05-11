// lib/provider/label_tree_provider.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/service/label_tree_service.dart';
import 'package:my_flutter_app/models/LabelTreeModel.dart';

class LabelTreeProvider with ChangeNotifier {
  final LabelTreeService _labelTreeService = LabelTreeService();
  List<LabelTreeModel> _labelTrees = [];

  List<LabelTreeModel> get labelTrees => _labelTrees;

  Future<void> fetchLabelTrees() async {
    try {
      _labelTrees = await _labelTreeService.getLabelTrees();
      notifyListeners();
    } catch (e) {
      throw Exception("Lỗi khi tải danh sách nhãn cây: $e");
    }
  }

  Future<void> addLabelTree(LabelTreeModel labelTree) async {
    try {
      await _labelTreeService.addLabelTree(labelTree);
      await fetchLabelTrees();
    } catch (e) {
      throw Exception("Lỗi khi thêm nhãn cây: $e");
    }
  }

  Future<void> editLabelTree(LabelTreeModel labelTree) async {
    try {
      await _labelTreeService.updateLabelTree(labelTree);
      await fetchLabelTrees();
    } catch (e) {
      throw Exception("Lỗi khi cập nhật nhãn cây: $e");
    }
  }

  Future<void> deleteLabelTree(String id) async {
    try {
      await _labelTreeService.deleteLabelTree(id);
      await fetchLabelTrees();
    } catch (e) {
      throw Exception("Lỗi khi xóa nhãn cây: $e");
    }
  }

  Future<List<String>> uploadImagesToCloudinary(List<File> imageFiles) async {
    try {
      return await _labelTreeService.uploadImagesToCloudinary(imageFiles);
    } catch (e) {
      throw Exception("Lỗi khi tải ảnh lên Cloudinary: $e");
    }
  }
}
