import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/LabelTreeModel.dart';
import 'package:provider/provider.dart';

import '../models/TreeModel.dart';
import '../provider/tree_provider.dart';

class LabelTreeCardCustom extends StatelessWidget {
  final LabelTreeModel labelTree;
  final VoidCallback onTap;

  const LabelTreeCardCustom({
    super.key,
    required this.labelTree,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final trees = Provider.of<TreeProvider>(context).trees;

    final treeName = trees
        .firstWhere(
          (tree) => tree.id == labelTree.categoryId,
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
                    child: labelTree.imageUrls != null && labelTree.imageUrls!.isNotEmpty
                        ? Image.network(
                      labelTree.imageUrls![0],
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
                          labelTree.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                treeName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.eco_rounded, size: 20, color: Colors.lightGreenAccent),
                            ],
                          ),
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
