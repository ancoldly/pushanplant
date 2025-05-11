import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/PostTreeModel.dart';

import '../views_admin/admin_editPostTree_screen.dart';

class PostTreeCard extends StatelessWidget {
  final PostTreeModel post;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PostTreeCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Card(
          color: Colors.white24,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: post.imageUrls!.isNotEmpty
                      ? Image.network(
                    post.imageUrls![0],
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminEditPostTreeScreen(post: post),
                          ),
                        );
                      }
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
                      onPressed: onDelete,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
