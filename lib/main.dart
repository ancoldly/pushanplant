import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_flutter_app/provider/label_tree_provider.dart';
import 'package:my_flutter_app/provider/post_social_provider.dart';
import 'package:my_flutter_app/provider/post_tree_provider.dart';
import 'package:my_flutter_app/provider/tree_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/routes/app_routes.dart';
import 'package:my_flutter_app/auth/user_provider.dart';

import 'auth/AuthWrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PostSocialProvider()..fetchPosts()),
        ChangeNotifierProvider(create: (_) => TreeProvider()..fetchTrees()),
        ChangeNotifierProvider(create: (_) => LabelTreeProvider()..fetchLabelTrees()),
        ChangeNotifierProvider(create: (_) => PostTreeProvider()..fetchPosts()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}