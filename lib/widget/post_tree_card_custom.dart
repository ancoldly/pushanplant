import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/PostTreeModel.dart';

class PostTreeCardCustom extends StatelessWidget {
  final PostTreeModel post;
  final VoidCallback onTap;

  const PostTreeCardCustom({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: post.imageUrls != null && post.imageUrls!.isNotEmpty
                        ? Image.network(
                      post.imageUrls!.first,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList()
                              : [],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
