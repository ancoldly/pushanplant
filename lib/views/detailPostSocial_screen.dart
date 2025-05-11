import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/PostSocialModel.dart';
import 'package:my_flutter_app/models/TreeModel.dart';
import 'package:my_flutter_app/models/UserModel.dart';
import 'package:my_flutter_app/service/post_social_service.dart';
import 'package:my_flutter_app/service/tree_service.dart';
import 'package:my_flutter_app/service/user_service.dart';
import 'package:provider/provider.dart';

import '../auth/user_provider.dart';
import '../provider/post_social_provider.dart';
import '../utils/toast_utils.dart';

class DetailPostSocialScreen extends StatefulWidget {
  const DetailPostSocialScreen({super.key});

  @override
  State<DetailPostSocialScreen> createState() => _DetailPostSocialScreenState();
}

class _DetailPostSocialScreenState extends State<DetailPostSocialScreen> {
  late Future<PostSocialModel> _postFuture;
  final PostSocialService _postSocialService = PostSocialService();
  final TreeService _treeService = TreeService();
  final UserService _userService = UserService();

  late String postSocialId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postSocialId = ModalRoute.of(context)!.settings.arguments as String;
    _postFuture = _postSocialService.getPostById(postSocialId);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<PostSocialModel>(
          future: _postFuture,
          builder: (context, snapshotPost) {
            if (snapshotPost.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshotPost.hasError || !snapshotPost.hasData) {
              return Center(
                child: Text(
                  'Lỗi: ${snapshotPost.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final post = snapshotPost.data!;

            return FutureBuilder<List<dynamic>>(
              future: Future.wait([
                post.relatedTreeId != null
                    ? _treeService.getTreeById(post.relatedTreeId!)
                    : Future.value(null),
                _userService.getUserById(post.idUser),
              ]),
              builder: (context, snapshotData) {
                if (snapshotData.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshotData.hasError) {
                  return Center(
                    child: Text(
                      'Lỗi khi tải dữ liệu: ${snapshotData.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final TreeModel? relatedTree = snapshotData.data![0];
                final UserModel creatorUser = snapshotData.data![1];

                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white, size: 30),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Chi tiết bài viết",
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
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    color: Colors.amberAccent, size: 30),
                                const SizedBox(width: 10),
                                Text(
                                  'Tác giả [${creatorUser.username}]',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (relatedTree != null)
                              Row(
                                children: [
                                  const Icon(Icons.eco,
                                      color: Colors.lightGreenAccent, size: 30),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Chủ đề về cây [${relatedTree.name}]',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.thumb_up,
                                    color: Colors.blueAccent),
                                const SizedBox(width: 10),
                                Text(
                                  '${post.likedBy?.length ?? 0} lượt thích',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ngày tạo: ${post.createdAt.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                                ),
                                Consumer<PostSocialProvider>(
                                  builder: (context, provider, child) {
                                    final isLiked = post.likedBy != null &&
                                        user != null &&
                                        post.likedBy!.contains(user.uid);

                                    return IconButton(
                                      icon: Icon(
                                        isLiked ? Icons.favorite : Icons.favorite_border,
                                        color: isLiked ? Colors.red : Colors.grey,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          if (isLiked) {
                                            post.likedBy!.remove(user.uid);
                                          } else {
                                            post.likedBy!.add(user!.uid);
                                          }
                                        });

                                        try {
                                          await provider.toggleLike(post.id, user!.uid);
                                        } catch (e) {
                                          setState(() {
                                            if (isLiked) {
                                              post.likedBy!.add(user.uid);
                                            } else {
                                              post.likedBy!.remove(user!.uid);
                                            }
                                          });
                                          ToastUtils.showErrorToast("Có lỗi khi thích bài viết.");
                                        }
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            post.imageUrls != null &&
                                post.imageUrls!.isNotEmpty
                                ? SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.imageUrls!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      child: Image.network(
                                        post.imageUrls![index],
                                        width: 300,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                                : const Center(
                              child: Icon(Icons.image_not_supported,
                                  size: 100, color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Ảnh minh hoạ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              post.content.toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (post.tags != null && post.tags!.isNotEmpty)
                              const Row(
                                children: [
                                  Icon(Icons.tag, color: Colors.blueAccent),
                                  SizedBox(width: 5),
                                  Text(
                                    "Tags",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 10),
                            if (post.tags != null && post.tags!.isNotEmpty)
                              Wrap(
                                spacing: 20,
                                runSpacing: 10,
                                children: post.tags!.map((tag) {
                                  return Chip(
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 5),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
