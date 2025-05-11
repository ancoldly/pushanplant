import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://10.0.2.2:8001";

  static Future<String?> sendImage(File image) async {
    var uri = Uri.parse("$_baseUrl/predict/");
    var request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath("file", image.path));

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 400) {
        var jsonResponse = json.decode(responseData);

        if (jsonResponse["status"] == "success") {
          return jsonResponse["result"]["prediction"] +
              " (Độ tin cậy: " +
              (jsonResponse["result"]["confidence"] * 100).toStringAsFixed(2) +
              "%)";
        } else {
          return "${jsonResponse["message"]}";
        }
      } else {
        return "Lỗi từ server.";
      }
    } catch (e) {
      return "Không thể kết nối đến server.";
    }
  }
}
