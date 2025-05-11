import 'package:flutter/material.dart';
import 'package:my_flutter_app/views_admin/admin_detailLabelTree_screen.dart';
import 'package:my_flutter_app/widget/label_tree_card.dart';
import '../models/LabelTreeModel.dart';
import '../models/TreeModel.dart';
import '../provider/tree_provider.dart';
import 'admin_detailTree_screen.dart';

import 'package:provider/provider.dart';
import '../provider/label_tree_provider.dart';

class AdminListLabelTreeScreen extends StatefulWidget {
  const AdminListLabelTreeScreen({super.key});

  @override
  _AdminListLabelTreeScreenState createState() =>
      _AdminListLabelTreeScreenState();
}

class _AdminListLabelTreeScreenState extends State<AdminListLabelTreeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LabelTreeProvider>(context, listen: false).fetchLabelTrees();
  }

  @override
  Widget build(BuildContext context) {
    final labelTreeProvider = Provider.of<LabelTreeProvider>(context);
    final treeProvider = Provider.of<TreeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Danh sách nhãn cây trồng",
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
              const Text(
                "Đây là danh sách các loại nhãn cây trồng.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: labelTreeProvider.fetchLabelTrees,
                  child: Consumer<LabelTreeProvider>(
                    builder: (context, labelTreeProvider, child) {
                      Map<String, List<LabelTreeModel>> groupedLabelTrees = {};
                      for (var labelTree in labelTreeProvider.labelTrees) {
                        groupedLabelTrees
                            .putIfAbsent(labelTree.categoryId, () => [])
                            .add(labelTree);
                      }

                      return ListView(
                        children: groupedLabelTrees.entries.map((entry) {
                          String categoryId = entry.key;
                          List<LabelTreeModel> labels = entry.value;

                          TreeModel? tree = treeProvider.trees.firstWhere(
                                  (tree) => tree.id == categoryId,
                              orElse: () => TreeModel(id: categoryId, name: 'Không xác định', description: '', imageUrl: '', createdAt: DateTime.now())
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Cây ${tree.name}",
                                  style: const TextStyle(
                                    color: Colors.amberAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...labels.map((labelTree) => LabelTreeCard(
                                label_tree: labelTree,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AdminDetailLabelTreeScreen(),
                                      settings: RouteSettings(arguments: labelTree.id),
                                    ),
                                  );
                                },
                                onDelete: () async {
                                  await labelTreeProvider.deleteLabelTree(labelTree.id);
                                },
                              )),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


