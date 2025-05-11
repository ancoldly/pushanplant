import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/auth/user_provider.dart';
import 'package:my_flutter_app/widget/user_info_tile.dart';
import 'package:my_flutter_app/routes/app_routes.dart';
import 'package:my_flutter_app/auth/auth_service.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';
import 'package:flutter/services.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final GlobalKey iconKey = GlobalKey();

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
                  const Text(
                    "Thông tin người dùng",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    key: iconKey,
                    icon: const Icon(Icons.settings, size: 30, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.edit_user);
                    },
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ClipOval(
                    child: Image(
                      image: (user?.avatarUrl?.isNotEmpty ?? false)
                          ? NetworkImage(user!.avatarUrl!)
                          : const AssetImage("assets/images/user_default.png") as ImageProvider,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user != null ? user.username.toString() : "Chưa có thông tin",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.verified, color: Colors.blueAccent, size: 25)
                        ],
                      ),
                      Text(
                        user != null ? user.email : "Chưa có thông tin",
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UserInfoTile(label: "Tên người dùng", value: user?.username),
                    UserInfoTile(label: "Email", value: user?.email),
                    UserInfoTile(label: "Số điện thoại", value: user?.numberPhone),
                    UserInfoTile(label: "Địa chỉ", value: user?.address),
                    Row(
                      children: [
                        const Icon(Icons.power_settings_new, color: Colors.white),
                        TextButton(
                          onPressed: () async {
                            try {
                              await Provider.of<UserProvider>(context, listen: false).logout();

                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.login, (route) => false,
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
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Member ID",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        user != null ? user.uid : "Chưa có thông tin",
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (user != null) {
                          Clipboard.setData(ClipboardData(text: user.uid)); // Sao chép UID vào clipboard
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Đã sao chép Member ID."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEEEEEE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Icon(Icons.copy_sharp, color: Colors.grey,)
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
