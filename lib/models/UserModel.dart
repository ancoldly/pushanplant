import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? avatarUrl;
  final String? address;
  final String? numberPhone;
  final String? role;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.avatarUrl,
    this.address,
    this.numberPhone,
    this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? 'Unknown',
      avatarUrl: data['avatarUrl'],
      address: data['address'],
      numberPhone: data['numberPhone'],
      role: data['role'],
      createdAt: (data['createdAt'] != null && data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'address': address,
      'numberPhone': numberPhone,
      'role': role,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? numberPhone,
    String? address,
    String? avatarUrl,
  }) {
    return UserModel(
      uid: uid,
      username: username ?? this.username,
      email: email ?? this.email,
      numberPhone: numberPhone ?? this.numberPhone,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role,
      createdAt: createdAt,
    );
  }
}
