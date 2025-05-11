import 'package:cloud_firestore/cloud_firestore.dart';

class LabelTreeModel {
  final String categoryId;
  final String id;
  final String name;
  final List<String>? imageUrls;
  final String? description;
  final DateTime createdAt;

  LabelTreeModel({
    required this.categoryId,
    required this.id,
    required this.name,
    this.imageUrls,
    this.description,
    required this.createdAt,
  });

  factory LabelTreeModel.fromMap(Map<String, dynamic> data, String id) {
    return LabelTreeModel(
      categoryId: data['categoryId'] ?? 'Chưa có danh mục',
      id: id,
      name: data['name'] ?? 'Chưa có tên',
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls'] as List)
          : [],
      description: data['description'] as String?,
      createdAt: data['createdAt'] != null && data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'id': id,
      'name': name,
      'imageUrls': imageUrls,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
