import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/auth/user_provider.dart';
import 'package:my_flutter_app/routes/app_routes.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';

import 'package:my_flutter_app/widget/custom_button_admin.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user!.username.toString(),
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await Provider.of<UserProvider>(context, listen: false)
                            .logout();

                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.login,
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        ToastUtils.showErrorToast("Lỗi đăng xuất!");
                      }
                    },
                    child: const Text(
                      "Đăng xuất",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  const Text(
                    "Hãy thao tác như một quản lý ứng dụng.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.admin_list_user);
                      },
                      text: "Danh sách người dùng",
                      icon: Icons.group,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.admin_add_category);
                      },
                      text: "Thêm loại cây trồng",
                      icon: Icons.eco_outlined,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.admin_list_tree);
                      },
                      text: "Danh sách cây trồng",
                      icon: Icons.eco_rounded,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.admin_add_label_tree);
                      },
                      text: "Thêm nhãn cây trồng",
                      icon: Icons.label,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.admin_list_label_tree);
                      },
                      text: "Danh sách nhãn cây trồng",
                      icon: Icons.coronavirus,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.admin_add_post);
                      },
                      text: "Tạo bài viết thông tin cây",
                      icon: Icons.post_add,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.admin_list_post_tree);
                      },
                      text: "Danh sách bài viết",
                      icon: Icons.view_list,
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
