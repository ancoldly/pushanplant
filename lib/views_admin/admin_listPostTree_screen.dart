import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/PostTreeModel.dart';
import 'package:my_flutter_app/provider/post_tree_provider.dart';
import 'package:my_flutter_app/views_admin/admin_DetailPostTree_screen.dart';import 'package:my_flutter_app/widget/post_tree_card.dart';
import 'package:provider/provider.dart';

class AdminListPostTreeScreen extends StatefulWidget {
  const AdminListPostTreeScreen({super.key});

  @override
  State<AdminListPostTreeScreen> createState() => _AdminListPostTreeScreenState();
}

class _AdminListPostTreeScreenState extends State<AdminListPostTreeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostTreeProvider>(context, listen: false).fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostTreeProvider>(context);

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
                  Text(
                    "Danh sách bài viết",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                "Các bài viết chia sẻ về cây trồng & bệnh cây.",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: postProvider.fetchPosts,
                  child: Consumer<PostTreeProvider>(
                    builder: (context, provider, _) {
                      final posts = provider.posts;
                      if (posts.isEmpty) {
                        return const Center(
                          child: Text(
                            "Chưa có bài viết nào.",
                            style: TextStyle(color: Colors.white60),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: posts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostTreeCard(
                            post: post,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminDetailPostTreeScreen(),
                                  settings: RouteSettings(arguments: post.id),
                                ),
                              );
                            },
                            onDelete: () async {
                              await postProvider.deletePost(post.id);
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
