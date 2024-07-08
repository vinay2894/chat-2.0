import 'dart:async';
import 'package:chat_app/controller/detail_controller.dart';
import 'package:chat_app/views/screens/chat_page.dart';
import 'package:chat_app/views/screens/detail_page.dart';
import 'package:chat_app/views/screens/home_page.dart';
import 'package:chat_app/views/screens/login_page.dart';
import 'package:chat_app/views/screens/signUp_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DetailPageController(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => LoginPage(),
        'signUp_page': (context) => SignUpPage(),
        'home_page': (context) => HomePage(),
        'detail_page': (context) => DetailsPage(),
        'chat_page': (context) => ChatPage(),
      },
    );
  }
}
