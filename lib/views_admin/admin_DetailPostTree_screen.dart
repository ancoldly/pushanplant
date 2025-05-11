import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/PostTreeModel.dart';
import 'package:my_flutter_app/service/post_tree_service.dart';
import 'package:my_flutter_app/service/tree_service.dart';

import '../models/TreeModel.dart';

class AdminDetailPostTreeScreen extends StatelessWidget {
  const AdminDetailPostTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String postTreeId =
    ModalRoute.of(context)!.settings.arguments as String;
    final postTreeService = PostTreeService();
    final treeService = TreeService();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            postTreeService.getPostById(postTreeId),
            postTreeService.getPostById(postTreeId).then((post) async {
              if (post.relatedTreeId != null) {
                return await treeService.getTreeById(post.relatedTreeId!);
              }
              return null;
            }),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Lỗi: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final PostTreeModel post = snapshot.data![0];
            final TreeModel? relatedTree = snapshot.data![1];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 30),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Chi tiết bài viết",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (relatedTree != null)
                          Row(
                            children: [
                              const Icon(Icons.eco,
                                  color: Colors.lightGreenAccent),
                              const SizedBox(width: 10),
                              Text(
                                'Chủ đề về cây [${relatedTree.name}]',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        Text(
                          'Ngày tạo: ${post.createdAt.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        post.imageUrls != null && post.imageUrls!.isNotEmpty
                            ? SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: post.imageUrls!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  child: Image.network(
                                    post.imageUrls![index],
                                    width: 300,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 100, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Ảnh minh hoạ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          post.content.toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (post.tags != null && post.tags!.isNotEmpty)
                          const Row(
                            children: [
                              Icon(Icons.tag, color: Colors.blueAccent),
                              SizedBox(width: 5),
                              Text(
                                "Tags",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        if (post.tags != null && post.tags!.isNotEmpty)
                          Wrap(
                            spacing: 20,
                            runSpacing: 10,
                            children: post.tags!.map((tag) {
                              return Chip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                backgroundColor: Colors.green,
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
