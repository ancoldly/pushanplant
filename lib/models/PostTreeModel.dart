import 'package:cloud_firestore/cloud_firestore.dart';

class PostTreeModel {
  final String id;
  final String title;
  final String? content;
  final List<String>? imageUrls;
  final String? relatedTreeId;
  final List<String>? tags;
  final DateTime createdAt;

  PostTreeModel({
    required this.id,
    required this.title,
    this.content,
    this.imageUrls,
    this.relatedTreeId,
    this.tags,
    required this.createdAt,
  });

  factory PostTreeModel.fromMap(Map<String, dynamic> data, String id) {
    return PostTreeModel(
      id: id,
      title: data['title'] ?? 'Không có tiêu đề',
      content: data['content'] ?? '',
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls'] as List)
          : [],
      relatedTreeId: data['relatedTreeId'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
      createdAt: data['createdAt'] != null && data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'relatedTreeId': relatedTreeId,
      'tags': tags,
      'createdAt': createdAt,
    };
  }
}
