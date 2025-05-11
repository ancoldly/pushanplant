import 'package:flutter/material.dart';
import 'package:my_flutter_app/views/addPostSocial_screen.dart';
import 'package:my_flutter_app/views/chatBot_screen.dart';
import 'package:my_flutter_app/views/detailLabelTree_screen.dart';
import 'package:my_flutter_app/views/edit_user_screen.dart';
import 'package:my_flutter_app/views/listPostTree_screen.dart';
import 'package:my_flutter_app/views/login_screen.dart';
import 'package:my_flutter_app/views/main_screen.dart';
import 'package:my_flutter_app/views/prediction_screen.dart';
import 'package:my_flutter_app/views/register_screen.dart';
import 'package:my_flutter_app/views/home_screen.dart';
import 'package:my_flutter_app/views/searchLabelTree_screen.dart';
import 'package:my_flutter_app/views/user_screen.dart';
import 'package:my_flutter_app/views_admin/admin_addCategory_screen.dart';
import 'package:my_flutter_app/views_admin/admin_addLabelTree_screen.dart';
import 'package:my_flutter_app/views_admin/admin_addPostTree_screen.dart';
import 'package:my_flutter_app/views_admin/admin_detailTree_screen.dart';
import 'package:my_flutter_app/views_admin/admin_home_screen.dart';
import 'package:my_flutter_app/views_admin/admin_listPostTree_screen.dart';
import 'package:my_flutter_app/views_admin/admin_listTree_screen.dart';

import '../views/listLabelTree_screen.dart';
import '../views_admin/admin_listLabelTree_screen.dart';
import '../views_admin/admin_listUser_screen.dart';

class AppRoutes {
  static const String login = "/login";
  static const String register = "/register";
  static const String main = "/main";
  static const String home = "/home";
  static const String user = "/user";
  static const String search_label_tree = "/search_label_tree";
  static const String detail_label_tree = "/detail_label_tree";
  static const String chat_bot = "/chat_bot";
  static const String edit_user = "/edit_user";
  static const String prediction = "/prediction";
  static const String list_label_tree = "/list_label_tree";
  static const String list_post_tree = "/list_post_tree";
  static const String add_post_social = "/add_post_social";
  static const String admin_home = "/admin_home";
  static const String admin_list_user = "/admin_list_user";
  static const String admin_list_tree = "/admin_list_tree";
  static const String admin_list_label_tree = "/admin_list_label_tree";
  static const String admin_list_post_tree = "/admin_list_post_tree";
  static const String admin_detail_tree = "/admin_detail_tree";
  static const String admin_add_category = "/admin_add_category";
  static const String admin_add_post = "/admin_add_post";
  static const String admin_add_label_tree = "/admin_add_label_tree";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case user:
        return MaterialPageRoute(builder: (_) => const UserScreen());
      case edit_user:
        return MaterialPageRoute(builder: (_) => const EditUserScreen());
      case prediction:
        return MaterialPageRoute(builder: (_) => const PredictionScreen());
      case list_label_tree:
        return MaterialPageRoute(builder: (_) => const ListLabelTreeScreen());
      case list_post_tree:
        return MaterialPageRoute(builder: (_) => const ListPostTreeScreen());
      case search_label_tree:
        return MaterialPageRoute(builder: (_) => const SearchLabelTreeScreen());
      case detail_label_tree:
        return MaterialPageRoute(builder: (_) => const DetailLabelTreeScreen());
      case chat_bot:
        return MaterialPageRoute(builder: (_) => const ChatBotScreen());
      case add_post_social:
        return MaterialPageRoute(builder: (_) => const AddPostSocialScreen());
      case admin_list_user:
        return MaterialPageRoute(builder: (_) => const AdminListUserScreen());
      case admin_list_tree:
        return MaterialPageRoute(builder: (_) => const AdminListTreeScreen());
      case admin_list_label_tree:
        return MaterialPageRoute(builder: (_) => const AdminListLabelTreeScreen());
      case admin_list_post_tree:
        return MaterialPageRoute(builder: (_) => const AdminListPostTreeScreen());
      case admin_detail_tree:
        return MaterialPageRoute(builder: (_) => const AdminDetailTreeScreen());
      case admin_home:
        return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
      case admin_add_category:
        return MaterialPageRoute(builder: (_) => const AdminAddCategoryScreen());
      case admin_add_post:
        return MaterialPageRoute(builder: (_) => const AdminAddPostTreeScreen());
      case admin_add_label_tree:
        return MaterialPageRoute(builder: (_) => const AdminAddLabelTreeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Không tìm thấy trang!")),
          ),
        );
    }
  }
}
