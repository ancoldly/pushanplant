import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/provider/label_tree_provider.dart';
import 'package:my_flutter_app/models/LabelTreeModel.dart';

import 'chatBot_screen.dart';

class ResultScreen extends StatefulWidget {
  final String predictionResult;
  final File selectedImage;

  const ResultScreen({
    super.key,
    required this.predictionResult,
    required this.selectedImage,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String disease = "Không xác định";
  String confidenceText = "Không rõ";
  bool isError = false;
  bool isNotLeafImage = false;
  LabelTreeModel? matchedLabel;

  @override
  void initState() {
    super.initState();
    parsePrediction();
    WidgetsBinding.instance.addPostFrameCallback((_) => matchWithLabelTree());
  }

  void parsePrediction() {
    if (widget.predictionResult.startsWith("Lỗi:")) {
      isError = true;
      disease = widget.predictionResult;
      confidenceText = "";
      return;
    }

    if (widget.predictionResult.toLowerCase().contains("không phải lá cây")) {
      isNotLeafImage = true;
      disease = "Ảnh không phải lá cây, vui lòng thử chọn một ảnh khác!";
      confidenceText = "Không xác định.";
      return;
    }

    final regExp = RegExp(r'Độ tin cậy:\s*(\d{1,3}\.\d+)%');
    final match = regExp.firstMatch(widget.predictionResult);

    if (match != null) {
      confidenceText = "${match.group(1)}%";
      disease = widget.predictionResult.replaceFirst(regExp, '').trim();

      disease = disease
          .replaceAll(RegExp(r'\(\s*\)'), '')
          .replaceAll(RegExp(r'\(\s*$'), '')
          .replaceAll(RegExp(r'\s*\)$'), '')
          .trim();
    } else {
      disease = widget.predictionResult.trim();
    }
  }

  void matchWithLabelTree() {
    if (isError || isNotLeafImage) return;
    final labelProvider =
    Provider.of<LabelTreeProvider>(context, listen: false);
    for (var label in labelProvider.labelTrees) {
      if (label.name.toLowerCase() == disease.toLowerCase()) {
        setState(() {
          matchedLabel = label;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHealthy = disease.toLowerCase().contains("healthy");

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isError
              ? Center(
            child: Text(
              disease,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )
              : Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Kết quả nhận diện lá cây",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Đây là thông tin kết quả của nhận diện lá cây.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        widget.selectedImage,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (isNotLeafImage)
                      Text(
                        disease,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      )
                    else
                      Text(
                        isHealthy ? disease : "🦠 Loại bệnh: $disease",
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),

                    const SizedBox(height: 10),

                      Text(
                        "🔍 Độ chính xác: $confidenceText",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    const SizedBox(height: 10),

                    if (matchedLabel != null) ...[
                      const Divider(color: Colors.white),
                      const SizedBox(height: 20),
                      if (matchedLabel!.imageUrls != null &&
                          matchedLabel!.imageUrls!.isNotEmpty)
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: matchedLabel!.imageUrls!.length,
                            itemBuilder: (context, index) {
                              final url =
                              matchedLabel!.imageUrls![index];
                              return Padding(
                                padding:
                                const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    url,
                                    height: 200,
                                    width: 230,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ảnh minh hoạ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatBotScreen(
                                    initialMessage: 'Chào bạn, tôi cần thông tin về $disease',
                                    checkArrow: true,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Tìm hiểu thêm?",
                              style: TextStyle(
                                color: Colors.amberAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Mô tả",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          matchedLabel!.description ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
