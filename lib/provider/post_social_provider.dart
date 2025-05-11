import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/PostSocialModel.dart';
import 'package:my_flutter_app/service/post_social_service.dart';

class PostSocialProvider with ChangeNotifier {
  final PostSocialService _postSocialService = PostSocialService();
  List<PostSocialModel> _posts = [];
  bool _isLoading = false;

  List<PostSocialModel> get posts => _posts;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    try {
      _setLoading(true);
      _posts = await _postSocialService.getPosts();
    } catch (e) {
      throw Exception("Lỗi khi tải danh sách bài viết xã hội: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPost(PostSocialModel post) async {
    try {
      await _postSocialService.addPost(post);
      await fetchPosts();
    } catch (e) {
      throw Exception("Lỗi khi thêm bài viết xã hội: $e");
    }
  }

  Future<void> updatePost(PostSocialModel post) async {
    try {
      await _postSocialService.updatePost(post);
    } catch (e) {
      throw Exception("Lỗi khi cập nhật bài viết xã hội: $e");
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _postSocialService.deletePost(id);
      await fetchPosts();
    } catch (e) {
      throw Exception("Lỗi khi xoá bài viết xã hội: $e");
    }
  }

  Future<List<String>> uploadImagesToCloudinary(List<File> imageFiles) async {
    try {
      return await _postSocialService.uploadImagesToCloudinary(imageFiles);
    } catch (e) {
      throw Exception("Lỗi khi tải ảnh lên Cloudinary: $e");
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      final post = _posts[postIndex];
      bool isLiked = post.likedBy?.contains(userId) ?? false;

      if (isLiked) {
        post.likedBy?.remove(userId);
      } else {
        post.likedBy?.add(userId);
      }

      _posts[postIndex] = post;

      notifyListeners();

      await _postSocialService.toggleLike(postId, userId);

    } catch (e) {
      throw Exception("Lỗi khi xử lý like/unlike bài viết: $e");
    }
  }

  PostSocialModel? getPostById(String id) {
    try {
      return _posts.firstWhere((post) => post.id == id, orElse: () => null as PostSocialModel);
    } catch (e) {
      return null;
    }
  }
}
