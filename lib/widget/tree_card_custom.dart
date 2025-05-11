import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/TreeModel.dart';

class TreeCardCustom extends StatelessWidget {
  final TreeModel tree;
  final VoidCallback onTap;

  const TreeCardCustom({
    super.key,
    required this.tree,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white10,
              border: Border.all(color: Colors.lightGreenAccent, width: 2),
            ),
            padding: const EdgeInsets.all(5),
            child: ClipOval(
              child: Image.network(
                tree.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 100,
            child: Text(
              tree.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
