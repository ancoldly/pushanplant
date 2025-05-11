import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/TreeModel.dart';

import '../views_admin/admin_editCategory_screen.dart';

class TreeCard extends StatelessWidget {
  final TreeModel tree;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TreeCard({
    super.key,
    required this.tree,
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
                  child: Image.network(
                    tree.imageUrl ?? '',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tree.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(Icons.eco_rounded, size: 30, color: Colors.lightGreenAccent),
                    ],
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
                            builder: (context) => AdminEditCategoryScreen(tree: tree),
                          ),
                        );
                      },
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
