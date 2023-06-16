// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';
import 'package:salsat_marketplace/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SalSat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      // MainScreen(), 
      WelcomeScreen(),
    );
  }
}

