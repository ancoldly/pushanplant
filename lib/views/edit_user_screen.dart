import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/auth/user_provider.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:provider/provider.dart';
import '../cloudinary/cloudinary.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.numberPhone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      final response = await cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'user_avatars/',
      );
      return response.secureUrl;
    } catch (e) {
      ToastUtils.showErrorToast("Lỗi khi tải ảnh lên Cloudinary.");
      return null;
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.user;

      if (currentUser == null) {
        ToastUtils.showErrorToast("Không tìm thấy người dùng.");
        return;
      }

      setState(() {
        _isUploading = true;
      });

      String? avatarUrl = currentUser.avatarUrl;

      if (_selectedImage != null) {
        avatarUrl = await _uploadImageToCloudinary(_selectedImage!);
        if (avatarUrl == null) {
          setState(() {
            _isUploading = false;
          });
          return;
        }
      }

      final updatedUser = currentUser.copyWith(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        numberPhone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        avatarUrl: avatarUrl,
      );

      try {
        await userProvider.updateUser(updatedUser);
        ToastUtils.showSuccessToast("Cập nhật thành công!");
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ToastUtils.showErrorToast("Có lỗi xảy ra khi cập nhật.");
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Cập nhật thông tin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                "Nếu cần, hãy cập nhật thông tin của bạn.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                                ? NetworkImage(user.avatarUrl!)
                                : const AssetImage("./assets/images/user_default.png")
                            as ImageProvider,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildInputField("Email", _emailController, readOnly: true),
                      const SizedBox(height: 20),
                      _buildInputField("Tên người dùng", _usernameController),
                      const SizedBox(height: 20),
                      _buildInputField("Số điện thoại", _phoneController),
                      const SizedBox(height: 20),
                      _buildInputField("Địa chỉ", _addressController),
                      const SizedBox(height: 30),
                      _isUploading
                          ? const Center(child: CircularProgressIndicator())
                          : Center(
                        child: SizedBox(
                          width: 300,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              _saveProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.white, width: 1),
                              ),
                            ),
                            child: const Text(
                              "Cập nhật thông tin người dùng",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
      ),
      validator: (value) {
        if (!readOnly && (value == null || value.trim().isEmpty)) {
          return "Vui lòng nhập $label";
        }
        return null;
      },
    );
  }
}
