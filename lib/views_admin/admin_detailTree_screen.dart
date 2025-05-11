import 'package:flutter/material.dart';
import 'package:my_flutter_app/service/tree_service.dart';
import '../models/TreeModel.dart';

class AdminDetailTreeScreen extends StatelessWidget {
  const AdminDetailTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String treeId = ModalRoute.of(context)!.settings.arguments as String;
    final TreeService _treeService = TreeService();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<TreeModel>(
          future: _treeService.getTreeById(treeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Không tìm thấy cây.', style: TextStyle(color: Colors.white)));
            }

            final tree = snapshot.data!;
            return Padding(
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
                        "Thông tin cây trồng",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                  const SizedBox(height: 20),
                  Text(
                    "Đây là thông tin chi tiết của cây ${tree.name}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  tree.imageUrl != null && tree.imageUrl!.isNotEmpty
                      ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        tree.imageUrl!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : const Center(
                    child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(tree.name,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(tree.description ?? 'Không có mô tả',
                      style: const TextStyle(color: Colors.white70, fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Ngày tạo: ${tree.createdAt.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 16)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
