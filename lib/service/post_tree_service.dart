import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'dart:io';
import 'package:my_flutter_app/models/PostTreeModel.dart';

final cloudinary = Cloudinary.signedConfig(
  apiKey: '231198986912915',
  apiSecret: 'HCFx9vDKaPHx-wyGr0f6sHfHw10',
  cloudName: 'dmt1tyw0x',
);

class PostTreeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(PostTreeModel post) async {
    try {
      await _firestore.collection('postTrees').add({
        'title': post.title,
        'content': post.content,
        'imageUrls': post.imageUrls ?? [],
        'relatedTreeId': post.relatedTreeId,
        'tags': post.tags ?? [],
        'createdAt': Timestamp.fromDate(post.createdAt),
      });
    } catch (e) {
      throw Exception("Failed to add post: $e");
    }
  }


  Future<PostTreeModel> getPostById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('postTrees').doc(id).get();

      if (!doc.exists) {
        throw Exception('Post không tồn tại');
      }

      return PostTreeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Lỗi khi lấy bài viết: $e');
    }
  }

  Future<List<PostTreeModel>> getPosts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('postTrees').get();

      return snapshot.docs.map((doc) {
        return PostTreeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách bài viết: $e');
    }
  }

  Future<void> updatePost(PostTreeModel post) async {
    try {
      await _firestore.collection('postTrees').doc(post.id).update(post.toMap());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật bài viết: $e');
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _firestore.collection('postTrees').doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa bài viết: $e');
    }
  }

  Future<List<String>> uploadImagesToCloudinary(List<File> imageFiles) async {
    List<String> imageUrls = [];

    try {
      for (var imageFile in imageFiles) {
        final response = await cloudinary.upload(
          file: imageFile.path,
          resourceType: CloudinaryResourceType.image,
          folder: 'post_tree_images/',
        );
        imageUrls.add(response.secureUrl.toString());
      }
    } catch (e) {
      throw Exception("Lỗi khi tải ảnh lên Cloudinary: $e");
    }

    return imageUrls;
  }
}
