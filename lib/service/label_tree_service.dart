import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'dart:io';  // Dành cho Flutter mobile
import 'package:my_flutter_app/models/LabelTreeModel.dart';

final cloudinary = Cloudinary.signedConfig(
  apiKey: '231198986912915',
  apiSecret: 'HCFx9vDKaPHx-wyGr0f6sHfHw10',
  cloudName: 'dmt1tyw0x',
);

class LabelTreeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLabelTree(LabelTreeModel labelTree) async {
    try {
      await _firestore.collection('labelTrees').add({
        'categoryId': labelTree.categoryId,
        'name': labelTree.name,
        'imageUrls': labelTree.imageUrls,
        'description': labelTree.description,
        'createdAt': labelTree.createdAt,
      });
    } catch (e) {
      throw Exception("Failed to add label tree: $e");
    }
  }

  Future<LabelTreeModel> getLabelTreeById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('labelTrees').doc(id).get();

      if (!doc.exists) {
        throw Exception('Label tree không tồn tại');
      }

      return LabelTreeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin label tree: $e');
    }
  }

  Future<List<LabelTreeModel>> getLabelTrees() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('labelTrees').get();

      return snapshot.docs.map((doc) {
        return LabelTreeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi tải danh sách label trees: $e');
    }
  }

  Future<void> updateLabelTree(LabelTreeModel labelTree) async {
    try {
      await _firestore.collection('labelTrees').doc(labelTree.id).update(labelTree.toMap());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật label tree: $e');
    }
  }

  Future<void> deleteLabelTree(String id) async {
    try {
      await _firestore.collection('labelTrees').doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa label tree: $e');
    }
  }

  Future<List<String>> uploadImagesToCloudinary(List<File> imageFiles) async {
    List<String> imageUrls = [];

    try {
      for (var imageFile in imageFiles) {
        final response = await cloudinary.upload(
          file: imageFile.path,
          resourceType: CloudinaryResourceType.image,
          folder: 'label_tree_images/',
        );
        imageUrls.add(response.secureUrl.toString());
      }
    } catch (e) {
      throw Exception("Lỗi khi tải ảnh lên Cloudinary: $e");
    }

    return imageUrls;
  }
}
