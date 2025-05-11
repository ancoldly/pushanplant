import 'package:flutter/material.dart';

class UserInfoTile extends StatelessWidget {
  final String label;
  final String? value;

  const UserInfoTile({
    Key? key,
    required this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          value ?? "Chưa có thông tin",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
