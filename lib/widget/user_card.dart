import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/UserModel.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image(
                    image: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                        ? const AssetImage("assets/images/user_default.png") as ImageProvider
                        : NetworkImage(user.avatarUrl!),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and verified icon
                    Row(
                      children: [
                        Text(
                          user.username ?? "Chưa có thông tin",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.verified, color: Colors.blueAccent, size: 25),
                      ],
                    ),
                    // Email
                    Text(
                      user.email ?? "Chưa có thông tin",
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // User role
            Text(
              user.role ?? 'Unknown',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
