import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'dart:io';
import 'package:my_flutter_app/models/PostSocialModel.dart';

final cloudinary = Cloudinary.signedConfig(
  apiKey: '231198986912915',
  apiSecret: 'HCFx9vDKaPHx-wyGr0f6sHfHw10',
  cloudName: 'dmt1tyw0x',
);

class PostSocialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(PostSocialModel post) async {
    try {
      await _firestore.collection('postSocials').add({
        'idUser': post.idUser,
        'title': post.title,
        'content': post.content,
        'relatedTreeId': post.relatedTreeId,
        'imageUrls': post.imageUrls ?? [],
        'tags': post.tags ?? [],
        'createdAt': Timestamp.fromDate(post.createdAt),
        'likedBy': post.likedBy ?? [],
      });
    } catch (e) {
      throw Exception("Lỗi khi thêm bài viết xã hội: $e");
    }
  }

  Future<PostSocialModel> getPostById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('postSocials').doc(id).get();

      if (!doc.exists) {
        throw Exception('Bài viết không tồn tại');
      }

      return PostSocialModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Lỗi khi lấy bài viết xã hội: $e');
    }
  }

  Future<List<PostSocialModel>> getPosts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('postSocials')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return PostSocialModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách bài viết xã hội: $e');
    }
  }

  Future<void> updatePost(PostSocialModel post) async {
    try {
      await _firestore.collection('postSocials').doc(post.id).update(post.toMap());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật bài viết xã hội: $e');
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _firestore.collection('postSocials').doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa bài viết xã hội: $e');
    }
  }

  Future<List<String>> uploadImagesToCloudinary(List<File> imageFiles) async {
    List<String> imageUrls = [];

    try {
      for (var imageFile in imageFiles) {
        final response = await cloudinary.upload(
          file: imageFile.path,
          resourceType: CloudinaryResourceType.image,
          folder: 'post_social_images/',
        );
        imageUrls.add(response.secureUrl.toString());
      }
    } catch (e) {
      throw Exception("Lỗi khi tải ảnh lên Cloudinary: $e");
    }

    return imageUrls;
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      final docRef = _firestore.collection('postSocials').doc(postId);
      final doc = await docRef.get();

      if (doc.exists) {
        List<dynamic> likedBy = doc['likedBy'] ?? [];

        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
        } else {
          likedBy.add(userId);
        }

        await docRef.update({'likedBy': likedBy});
      }
    } catch (e) {
      throw Exception("Lỗi khi like bài viết: $e");
    }
  }
}
