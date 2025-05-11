import 'package:cloud_firestore/cloud_firestore.dart';

class TreeModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? description;
  final DateTime createdAt;

  TreeModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    required this.createdAt,
  });

  factory TreeModel.fromMap(Map<String, dynamic> data, String id) {
    return TreeModel(
      id: id,
      name: data['name'] ?? 'Chưa có tên',
      imageUrl: data['imageUrl'] as String?,
      description: data['description'] as String?,
      createdAt: data['createdAt'] != null && data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
