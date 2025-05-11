import 'package:flutter/material.dart';
import 'package:my_flutter_app/routes/app_routes.dart';
import 'package:my_flutter_app/auth/auth_service.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';

import '../auth/AuthWrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  void _loginUser() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ToastUtils.showErrorToast("Vui lòng điền đầy đủ thông tin!");
      return;
    }

    setState(() => isLoading = true); 

    String res = await AuthService().loginUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (res == "success") {
      ToastUtils.showSuccessToast("Đăng nhập thành công!");
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AuthWrapper()),
          );
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
                  "Đăng nhập tài khoản của bạn",
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
                  "Chỉ hỗ trợ đăng nhập qua email, bạn vui lòng đăng nhập để trải nghiệm ứng dụng.",
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
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: !isPasswordVisible,
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
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Đăng Nhập",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      print("Chuyển đến màn hình quên mật khẩu!");
                    },
                    child: const Text(
                      "Quên mật khẩu?",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: const Text(
                      "Đăng ký",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Hoặc",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal)),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    print("Đăng nhập bằng Google!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("./assets/images/google.png",
                          width: 30, height: 30),
                      const SizedBox(width: 10),
                      const Text(
                        "Đăng nhập bằng Google",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    print("Đăng nhập bằng FacebookFacebook!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("./assets/images/facebook.png",
                          width: 30, height: 30),
                      const SizedBox(width: 10),
                      const Text(
                        "Đăng nhập bằng Facebook",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
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
