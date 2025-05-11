import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<String> registerUser({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return "Mật khẩu xác nhận không trùng khớp!";
    }

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "email": email,
          "createdAt": FieldValue.serverTimestamp(),
          "username": username,
          "avatarUrl": null,
          "address": null,
          "numberPhone": null,
          "role": "user"
        });
      } catch (e) {
        return "Lỗi khi lưu dữ liệu Firestore: ${e.toString()}";
      }

      return "success";
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } on PlatformException catch (e) {
      return "Lỗi hệ thống Firebase: ${e.message}";
    } catch (e) {
      return "Lỗi không xác định: ${e.toString()}";
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      return _handleAuthError(e);
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code} - ${e.message}");
      return "Lỗi hệ thống Firebase: ${e.message}";
    } catch (e) {
      print("Exception: ${e.toString()}");
      return "Lỗi không xác định: ${e.toString()}";
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    print("🔥 Firebase Error Code: ${e.code} - Message: ${e.message}");

    switch (e.code) {
      case "invalid-email":
        return "Email không hợp lệ!";
      case "email-already-in-use":
        return "Email này đã được đăng ký!";
      case "weak-password":
        return "Mật khẩu quá yếu! Hãy chọn mật khẩu mạnh hơn.";
      case "wrong-password":
        return "Sai mật khẩu! Vui lòng kiểm tra lại.";
      case "user-not-found":
        return "Tài khoản không tồn tại! Hãy kiểm tra email của bạn.";
      case "operation-not-allowed":
        return "Tài khoản này chưa được kích hoạt!";
      case "too-many-requests":
        return "Quá nhiều yêu cầu! Vui lòng thử lại sau.";
      case "network-request-failed":
        return "Lỗi kết nối mạng! Hãy kiểm tra Internet của bạn.";
      case "user-disabled":
        return "Tài khoản đã bị vô hiệu hóa! Liên hệ quản trị viên.";
      default:
        return "Lỗi không xác định: ${e.message}";
    }
  }
}
