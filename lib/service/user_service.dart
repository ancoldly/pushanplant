import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/models/UserModel.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users')
          .where('role', isEqualTo: 'user')
          .get();

      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<void> updateUserInFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật người dùng: $e');
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        return UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy người dùng theo ID: $e');
    }
  }
}
