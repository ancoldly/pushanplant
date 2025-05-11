import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/PostTreeModel.dart';
import 'package:my_flutter_app/service/post_tree_service.dart';

class PostTreeProvider with ChangeNotifier {
  final PostTreeService _postTreeService = PostTreeService();
  List<PostTreeModel> _posts = [];

  List<PostTreeModel> get posts => _posts;

  Future<void> fetchPosts() async {
    try {
      _posts = await _postTreeService.getPosts();
      notifyListeners();
    } catch (e) {
      throw Exception("Lỗi khi tải danh sách bài viết: $e");
    }
  }

  Future<void> addPost(PostTreeModel post) async {
    try {
      await _postTreeService.addPost(post);
      await fetchPosts();
    } catch (e) {
      throw Exception("Lỗi khi thêm bài viết: $e");
    }
  }

  Future<void> updatePost(PostTreeModel post) async {
    try {
      await _postTreeService.updatePost(post);
      await fetchPosts();
    } catch (e) {
      throw Exception("Lỗi khi cập nhật bài viết: $e");
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _postTreeService.deletePost(id);
      await fetchPosts();
    } catch (e) {
      throw Exception("Lỗi khi xoá bài viết: $e");
    }
  }

  Future<List<String>> uploadImagesToCloudinary(List<File> imageFiles) async {
    try {
      return await _postTreeService.uploadImagesToCloudinary(imageFiles);
    } catch (e) {
      throw Exception("Lỗi khi tải ảnh lên Cloudinary: $e");
    }
  }
}
