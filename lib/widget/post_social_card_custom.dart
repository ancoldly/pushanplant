import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/user_provider.dart';
import '../models/PostSocialModel.dart';
import '../models/TreeModel.dart';
import '../models/UserModel.dart';
import '../provider/tree_provider.dart';

class PostSocialCard extends StatelessWidget {
  final PostSocialModel post;
  final VoidCallback onTap;

  const PostSocialCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final treeProvider = Provider.of<TreeProvider>(context);

    final users = userProvider.users;
    final trees = treeProvider.trees;

    final userName = users
        .firstWhere(
          (user) => user.uid == post.idUser,
      orElse: () => UserModel(
        uid: '',
        email: '',
        username: 'Không rõ',
        avatarUrl: null,
        address: null,
        numberPhone: null,
        role: null,
        createdAt: DateTime.now(),
      ),
    )
        .username;

    final treeName = trees
        .firstWhere(
          (tree) => tree.id == post.relatedTreeId,
      orElse: () => TreeModel(
        id: '',
        name: 'Không rõ',
        description: '',
        imageUrl: '',
        createdAt: DateTime.now(),
      ),
    )
        .name;

    return SizedBox(
      width: 350,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Card(
            color: Colors.white24,
            elevation: 4,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.white30, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị ảnh
                  post.imageUrls != null && post.imageUrls!.isNotEmpty
                      ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            post.imageUrls![0],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        post.imageUrls!.length > 1
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            post.imageUrls![1],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  )
                      : const SizedBox.shrink(),

                  const SizedBox(height: 20),

                  Text(
                    'Người tạo bài viết [$userName]',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                    ),
                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Text(
                        treeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      const Icon(Icons.eco, size: 30, color: Colors.lightGreenAccent)
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: post.tags != null
                        ? post.tags!.take(2).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList()
                        : [],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ngày tạo: ${post.createdAt.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),

                      const IconButton(onPressed: null, icon: Icon(Icons.signpost_rounded, size: 30, color: Colors.white))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
