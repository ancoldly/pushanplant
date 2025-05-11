import 'package:flutter/material.dart';
import 'package:my_flutter_app/widget/label_tree_card_custom.dart';
import '../models/LabelTreeModel.dart';
import '../models/TreeModel.dart';
import '../provider/tree_provider.dart';
import 'package:provider/provider.dart';
import '../provider/label_tree_provider.dart';
import 'detailLabelTree_screen.dart';

class ListLabelTreeScreen extends StatefulWidget {
  const ListLabelTreeScreen({super.key});

  @override
  State<ListLabelTreeScreen> createState() => _ListLabelTreeScreenState();
}

class _ListLabelTreeScreenState extends State<ListLabelTreeScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<LabelTreeProvider>(context).fetchLabelTrees().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
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
                    onPressed: () => Navigator.of(context).pop(),
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                    : RefreshIndicator(
                  onRefresh: () async {
                    await labelTreeProvider.fetchLabelTrees();
                  },
                  child: Consumer<LabelTreeProvider>(
                    builder: (context, labelProvider, _) {
                      final groupedLabelTrees = <String, List<LabelTreeModel>>{};
                      for (var label in labelProvider.labelTrees) {
                        groupedLabelTrees.putIfAbsent(label.categoryId, () => []).add(label);
                      }

                      if (groupedLabelTrees.isEmpty) {
                        return const Center(
                          child: Text(
                            "Chưa có nhãn cây trồng nào.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return ListView(
                        children: groupedLabelTrees.entries.map((entry) {
                          final categoryId = entry.key;
                          final labels = entry.value;

                          final tree = treeProvider.trees.firstWhere(
                                (tree) => tree.id == categoryId,
                            orElse: () => TreeModel(
                              id: categoryId,
                              name: 'Không xác định',
                              description: '',
                              imageUrl: '',
                              createdAt: DateTime.now(),
                            ),
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "${tree.name} 🌳",
                                  style: const TextStyle(
                                    color: Colors.amberAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...labels.map(
                                    (labelTree) => LabelTreeCardCustom(
                                  labelTree: labelTree,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const DetailLabelTreeScreen(),
                                        settings: RouteSettings(arguments: labelTree.id),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
