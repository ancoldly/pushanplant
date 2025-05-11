import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/auth/user_provider.dart';
import 'package:my_flutter_app/views/login_screen.dart';
import 'package:my_flutter_app/views/main_screen.dart';
import 'package:my_flutter_app/views_admin/admin_home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          return const LoginScreen();
        }

        if (userProvider.user == null) {
          userProvider.fetchUserRole();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return userProvider.isAdmin ? const AdminHomeScreen() : const MainScreen();
      },
    );
  }
}
