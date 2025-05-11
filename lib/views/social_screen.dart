import 'package:flutter/material.dart';
import 'package:my_flutter_app/views/detailPostSocial_screen.dart';
import 'package:provider/provider.dart';
import '../provider/post_social_provider.dart';
import '../routes/app_routes.dart';
import '../widget/post_social_card_custom.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<PostSocialProvider>(context).fetchPosts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postSocialProvider = Provider.of<PostSocialProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Trao đổi & chia sẻ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.add_post_social,
                      );
                    },
                    icon: const Icon(
                      Icons.post_add,
                      color: Colors.amberAccent,
                      size: 30,
                    ),
                  )
                ],
              ),
              const Divider(color: Colors.white, thickness: 1),
              const SizedBox(height: 20),
              const Text(
                "Trao đổi, chia sẻ thông tin với nhau...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                    : RefreshIndicator(
                  onRefresh: () async {
                    await postSocialProvider.fetchPosts();
                  },
                  child: Consumer<PostSocialProvider>(
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
                          final post = postProvider.posts[index];
                          return PostSocialCard(
                            post: post,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DetailPostSocialScreen(),
                                  settings: RouteSettings(arguments: post.id),
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
