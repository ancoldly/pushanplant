import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:my_flutter_app/service/tree_service.dart';
import '../models/TreeModel.dart';

class TreeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTree(String name, String description, String imageUrl) async {
    try {
      await _firestore.collection('trees').add({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add tree: $e');
    }
  }

  Future<TreeModel> getTreeById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('trees').doc(id).get();

      if (!doc.exists) {
        throw Exception('Cây không tồn tại');
      }

      return TreeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin cây: $e');
    }
  }

  Future<List<TreeModel>> getTrees() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('trees').get();

      return snapshot.docs.map((doc) {
        return TreeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi tải cây: $e');
    }
  }

  Future<void> deleteTree(String id) async {
    try {
      await _firestore.collection('trees').doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa cây: $e');
    }
  }

  Future<void> updateTree(TreeModel tree) async {
    try {
      await _firestore.collection('trees').doc(tree.id).update(tree.toMap());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật cây: $e');
    }
  }
}
