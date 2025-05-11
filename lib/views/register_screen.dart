import 'package:flutter/material.dart';
import 'package:my_flutter_app/routes/app_routes.dart';
import 'package:my_flutter_app/auth/auth_service.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  void _registerUser() async {
    if (emailController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      ToastUtils.showErrorToast("Vui lòng điền đầy đủ thông tin!");
      return;
    }

    setState(() => isLoading = true);

    String res = await AuthService().registerUser(
      email: emailController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    if (mounted) {
      setState(() => isLoading = false);
    }

    if (res == "success") {
      ToastUtils.showSuccessToast("Đăng ký thành công!");

        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pushNamed(context, AppRoutes.login);
          }
        });
    } else {
      ToastUtils.showErrorToast(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco_outlined, color: Colors.blueAccent, size: 60),
                  SizedBox(width: 10),
                  Text(
                    "PushanPlant",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontFamily: "Courier New"),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Tạo tài khoản mới",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Chỉ hỗ trợ đăng ký bằng email trong khu vực của bạn.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Tên người dùng",
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Xác nhận mật khẩu",
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.blueAccent),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Đăng Ký",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Đã có tài khoản?",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
