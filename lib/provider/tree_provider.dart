import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/TreeModel.dart';
import '../service/tree_service.dart';

class TreeProvider with ChangeNotifier {
  final TreeService _treeService = TreeService();
  List<TreeModel> _trees = [];

  List<TreeModel> get trees => _trees;

  bool isLoading = false;

  Future<void> fetchTrees() async {
    _trees = await _treeService.getTrees();
    notifyListeners();
  }

  Future<void> deleteTree(String id) async {
    await _treeService.deleteTree(id);
    await fetchTrees();
  }

  Future<void> addTree(String name, String description, String imageUrl) async {
    await _treeService.addTree(name, description, imageUrl);
    await fetchTrees();
  }

  Future<void> editTree(String id, String name, String description, String imageUrl) async {
    TreeModel existingTree = await _treeService.getTreeById(id);

    TreeModel updatedTree = TreeModel(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      createdAt: existingTree.createdAt,
    );

    await _treeService.updateTree(updatedTree);
    await fetchTrees();
  }

  Future<TreeModel?> getTreeById(String id) async {
    try {
      return await _treeService.getTreeById(id);
    } catch (e) {
      return null;
    }
  }
}



