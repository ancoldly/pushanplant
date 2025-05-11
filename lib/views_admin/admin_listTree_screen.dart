import 'package:flutter/material.dart';
import 'package:my_flutter_app/widget/tree_card.dart';
import 'package:my_flutter_app/service/tree_service.dart';
import 'package:my_flutter_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../models/TreeModel.dart';
import '../provider/tree_provider.dart';
import '../utils/toast_utils.dart';
import 'admin_detailTree_screen.dart';
import 'admin_editCategory_screen.dart';

class AdminListTreeScreen extends StatefulWidget {
  const AdminListTreeScreen({super.key});

  @override
  _AdminListTreeScreenState createState() => _AdminListTreeScreenState();
}

class _AdminListTreeScreenState extends State<AdminListTreeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TreeProvider>(context, listen: false).fetchTrees();
  }

  @override
  Widget build(BuildContext context) {
    final treeProvider = Provider.of<TreeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  BackButton(color: Colors.white),
                  SizedBox(width: 10),
                  Text("Danh sách cây trồng",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
              const Divider(color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                "Đây là danh sách các loại cây trồng.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: treeProvider.fetchTrees,
                  child: Consumer<TreeProvider>(
                    builder: (context, treeProvider, child) {
                      return ListView.separated(
                        itemCount: treeProvider.trees.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          TreeModel tree = treeProvider.trees[index];
                          return TreeCard(
                            tree: tree,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminDetailTreeScreen(),
                                  settings: RouteSettings(arguments: tree.id),
                                ),
                              );
                            },
                            onDelete: () async {
                              await treeProvider.deleteTree(tree.id);
                            },
                          );
                        },
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



