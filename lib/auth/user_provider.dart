import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/models/UserModel.dart';
import '../service/user_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  List<UserModel> _users = [];
  bool _isLoading = false;

  UserModel? get user => _user;
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  final UserService _userService = UserService();

  UserProvider() {
    _listenToAuthChanges();
  }

  void setUserToNull() {
    _user = null;
    notifyListeners();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
        _users.clear();
        notifyListeners();
      } else {
        await _fetchUserData(firebaseUser.uid);
        await fetchUsers();
      }
    });
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (userDoc.exists) {
        _user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        _user = null;
      }
    } catch (e) {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<UserModel> usersList = await _userService.getUsers();
      _users = usersList;
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách người dùng: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserRole() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await _fetchUserData(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await _userService.updateUserInFirestore(updatedUser);
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  bool get isAdmin => _user?.role == 'admin';

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    _users.clear();
    notifyListeners();
  }

  UserModel? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.uid == userId);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> fetchUserById(String userId) async {
    UserModel? existingUser = getUserById(userId);
    if (existingUser != null) {
      return existingUser;
    }

    try {
      UserModel? user = await _userService.getUserById(userId);
      if (user != null) {
        _users.add(user);
        notifyListeners();
        return user;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin người dùng: $e');
    }
  }
}
