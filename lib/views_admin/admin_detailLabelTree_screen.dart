import 'package:flutter/material.dart';
import 'package:my_flutter_app/service/label_tree_service.dart';
import 'package:my_flutter_app/models/LabelTreeModel.dart';

class AdminDetailLabelTreeScreen extends StatelessWidget {
  const AdminDetailLabelTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String labelTreeId =
    ModalRoute.of(context)!.settings.arguments as String;
    final LabelTreeService _labelTreeService = LabelTreeService();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<LabelTreeModel>(
          future: _labelTreeService.getLabelTreeById(labelTreeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Lỗi: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData) {
              return const Center(
                  child: Text('Không tìm thấy nhãn cây.',
                      style: TextStyle(color: Colors.white)));
            }

            final labelTree = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                        "Thông tin nhãn cây trồng",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          "Đây là thông tin chi tiết của nhãn cây ${labelTree.name}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        labelTree.imageUrls != null && labelTree.imageUrls!.isNotEmpty
                            ? SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: labelTree.imageUrls!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    labelTree.imageUrls![index],
                                    height: 200,
                                    width: 300,
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
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(labelTree.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(labelTree.description ?? 'Không có mô tả',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 18)),
                        const SizedBox(height: 10),
                        Text(
                            'Ngày tạo: ${labelTree.createdAt.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(
                                color: Colors.amberAccent, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
