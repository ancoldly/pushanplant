import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/provider/label_tree_provider.dart';
import 'package:my_flutter_app/provider/post_tree_provider.dart';
import 'package:my_flutter_app/auth/user_provider.dart';
import 'package:my_flutter_app/widget/label_tree_card_custom.dart';
import 'package:provider/provider.dart';
import '../provider/tree_provider.dart';
import '../routes/app_routes.dart';
import '../views_admin/admin_DetailPostTree_screen.dart';
import '../views_admin/admin_detailTree_screen.dart';
import '../widget/post_tree_card_custom.dart';
import '../widget/tree_card_custom.dart';
import 'detailLabelTree_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final context = this.context;
      Provider.of<TreeProvider>(context, listen: false).fetchTrees();
      Provider.of<LabelTreeProvider>(context, listen: false).fetchLabelTrees();
      Provider.of<PostTreeProvider>(context, listen: false).fetchPosts();
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good morning";
    } else if (hour >= 12 && hour < 18) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Pushan Plant",
                            style: TextStyle(
                              color: Colors.lightGreenAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.eco,
                              color: Colors.lightGreenAccent, size: 30),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.search_label_tree,
                          );
                        },
                        icon: const Icon(Icons.search,
                            color: Colors.white, size: 30),
                      )
                    ],
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final treeProvider =
                        Provider.of<TreeProvider>(context, listen: false);
                    final labelTreeProvider =
                        Provider.of<LabelTreeProvider>(context, listen: false);
                    final postTreeProvider =
                        Provider.of<PostTreeProvider>(context, listen: false);

                    await Future.wait([
                      treeProvider.fetchTrees(),
                      labelTreeProvider.fetchLabelTrees(),
                      postTreeProvider.fetchPosts(),
                    ]);
                  },
                  child: ListView(
                    children: [
                      Text(
                        getGreeting(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "Chúc bạn có một trải nghiệm tuyệt vời.",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Tìm hiểu các loại cây",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: Consumer<TreeProvider>(
                          builder: (context, treeProvider, child) {
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: treeProvider.trees.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final tree = treeProvider.trees[index];
                                return TreeCardCustom(
                                  tree: tree,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AdminDetailTreeScreen(),
                                        settings:
                                            RouteSettings(arguments: tree.id),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tìm hiểu các loại bệnh",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.list_label_tree,
                              );
                            },
                            child: const Text(
                              "Xem tất cả",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Consumer<LabelTreeProvider>(
                        builder: (context, labelTreeProvider, child) {
                          final labelTrees = [...labelTreeProvider.labelTrees];
                          if (labelTrees.length > 3) {
                            labelTrees.shuffle(Random());
                          }
                          final displayedLabelTrees =
                              labelTrees.take(3).toList();

                          return Column(
                            children: displayedLabelTrees.map((labelTree) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: LabelTreeCardCustom(
                                  labelTree: labelTree,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const DetailLabelTreeScreen(),
                                        settings: RouteSettings(
                                            arguments: labelTree.id),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tiếp cận thông tin",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.list_post_tree,
                              );
                            },
                            child: const Text(
                              "Xem thêm",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Consumer<PostTreeProvider>(
                        builder: (context, postProvider, child) {
                          final posts = [...postProvider.posts];
                          if (posts.length > 2) {
                            posts.shuffle(Random());
                          }
                          final displayedPosts = posts.take(2).toList();

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: displayedPosts.map((post) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: PostTreeCardCustom(
                                    post: post,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const AdminDetailPostTreeScreen(),
                                          settings:
                                              RouteSettings(arguments: post.id),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
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
