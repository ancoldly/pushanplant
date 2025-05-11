import 'package:flutter/material.dart';
import 'package:my_flutter_app/views_admin/admin_detailPostTree_screen.dart';
import 'package:my_flutter_app/widget/post_tree_card_custom.dart';
import '../models/PostTreeModel.dart';
import '../provider/post_tree_provider.dart';
import 'package:provider/provider.dart';

class ListPostTreeScreen extends StatefulWidget {
  const ListPostTreeScreen({super.key});

  @override
  State<ListPostTreeScreen> createState() => _ListPostTreeScreenState();
}

class _ListPostTreeScreenState extends State<ListPostTreeScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<PostTreeProvider>(context).fetchPosts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postTreeProvider = Provider.of<PostTreeProvider>(context);

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
                    "Danh sách bài viết cây trồng",
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
                "Đây là danh sách các bài viết về cây trồng.",
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
                    await postTreeProvider.fetchPosts();
                  },
                  child: Consumer<PostTreeProvider>(
                    builder: (context, postProvider, _) {
                      if (postProvider.posts.isEmpty) {
                        return const Center(
                          child: Text(
                            "Chưa có bài viết nào.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: postProvider.posts.length,
                        itemBuilder: (ctx, index) {
                          final postTree = postProvider.posts[index];
                          return PostTreeCardCustom(
                            post: postTree,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminDetailPostTreeScreen(),
                                  settings: RouteSettings(arguments: postTree.id),
                                ),
                              );
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
