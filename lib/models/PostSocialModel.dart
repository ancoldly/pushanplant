import 'package:cloud_firestore/cloud_firestore.dart';

class PostSocialModel {
  final String id;
  final String idUser;
  final String title;
  final String? content;
  final List<String>? imageUrls;
  final List<String>? tags;
  final String? relatedTreeId;
  final DateTime createdAt;
  final List<String>? likedBy;

  PostSocialModel({
    required this.id,
    required this.idUser,
    required this.title,
    this.content,
    this.imageUrls,
    this.tags,
    this.relatedTreeId,
    required this.createdAt,
    this.likedBy,
  });

  factory PostSocialModel.fromMap(Map<String, dynamic> data, String id) {
    return PostSocialModel(
      id: id,
      idUser: data['idUser'] ?? '',
      title: data['title'] ?? 'Không có tiêu đề',
      content: data['content'] ?? '',
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls'] as List)
          : [],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
      relatedTreeId: data['relatedTreeId'],
      createdAt: data['createdAt'] != null && data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      likedBy: data['likedBy'] != null ? List<String>.from(data['likedBy']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'tags': tags,
      'relatedTreeId': relatedTreeId,
      'createdAt': createdAt,
      'likedBy': likedBy ?? [],
    };
  }
}
