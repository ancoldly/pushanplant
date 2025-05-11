import 'package:flutter/material.dart';
import 'package:my_flutter_app/widget/user_card.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/auth/user_provider.dart';
import 'package:my_flutter_app/routes/app_routes.dart';
import 'package:my_flutter_app/utils/toast_utils.dart';
import 'package:my_flutter_app/models/UserModel.dart';
import 'package:my_flutter_app/service/user_service.dart';

class AdminListUserScreen extends StatelessWidget {
  const AdminListUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final UserService _userService = UserService();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Danh sách người dùng",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              const Text(
                "Đây chính là danh sách người dùng ứng dụng.",
                style: TextStyle(color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<UserModel>>(
                future: _userService.getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<UserModel> users = snapshot.data!;

                    return Expanded(
                      child: ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 5),
                        itemBuilder: (context, index) {
                          UserModel user = users[index];
                          return UserCard(user: user);
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('Không có người dùng.'));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
