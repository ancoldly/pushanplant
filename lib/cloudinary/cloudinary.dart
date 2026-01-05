import 'dart:io';
import 'package:cloudinary/cloudinary.dart';

final cloudinary = Cloudinary.signedConfig(
  apiKey: '231198986912915',
  apiSecret: 'HCFx9vDKaPHx-wyGr0f6sHfHw10',
  cloudName: 'dmt1tyw0x',
);

Future<List<String>> uploadImagesToCloudinary(List<File> imageFiles) async {
  List<String> imageUrls = [];

  try {
    for (var imageFile in imageFiles) {
      final response = await cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'label_tree_images/',
      );
      imageUrls.add(response.secureUrl.toString());
    }
  } catch (e) {
    throw Exception("Lỗi khi tải ảnh lên Cloudinary: $e");
  }

  return imageUrls;
}


