import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/LabelTreeModel.dart';
import 'package:my_flutter_app/views_admin/admin_editLabelTree_screen.dart';

class LabelTreeCard extends StatelessWidget {
  final LabelTreeModel label_tree;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const LabelTreeCard({super.key, required this.label_tree, required this.onTap, required this.onDelete});

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
                    label_tree.imageUrls?[0] ?? '',
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
                        label_tree.name.length > 18
                            ? '${label_tree.name.substring(0, 18)}...'
                            : label_tree.name,
                        style: const TextStyle(
                          fontSize: 18,
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
                            builder: (context) => AdminEditLabelTreeScreen(labelTree: label_tree),
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
