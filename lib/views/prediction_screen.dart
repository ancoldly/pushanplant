import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:my_flutter_app/api/api_service.dart';
import 'package:my_flutter_app/views/result_screen.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File image = File(pickedFile.path);

      String? result = await ApiService.sendImage(image);
      if (context.mounted && result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              predictionResult: result,
              selectedImage: image,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nhận diện hình ảnh",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.add_a_photo, color: Colors.white, size: 30),
                      onPressed: null),
                ],
              ),
              const Divider(color: Colors.white, thickness: 1),
              const SizedBox(height: 20),
              const Text(
                "Chào bạn, thử trải nghiệm thử tôi nhé.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          './assets/images/tree.png',
                          width: 250,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Nhanh chóng nhận diện các loại bệnh trong vài giây! Chỉ cần '
                              'chụp một bức ảnh hoặc chọn một ảnh từ thư viện của bạn, '
                              'và để AI của chúng tôi làm phần còn lại.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.lightbulb, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Mẹo để nhận diện lá cây',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.white, thickness: 1),
                          SizedBox(height: 10),
                          Text(
                            '1. Đảm bảo lá cây được chiếu sáng tốt và nằm ở giữa bức ảnh.',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '2. Tránh hình ảnh mờ để có kết quả chính xác.',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '3. Cố gắng chụp một bức ảnh rõ nét của lá cây hoặc các đặc điểm nhận dạng độc đáo.',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => _pickImage(ImageSource.camera),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.amberAccent, width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.camera_alt, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Máy ảnh',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        OutlinedButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.amberAccent, width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.image_outlined, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Chọn từ thư viện',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
