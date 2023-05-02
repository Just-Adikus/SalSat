import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import '/views/login_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'generated/codegen_loader.g.dart';

// 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: CodegenLoader(),
      locale: Locale('ru'),
      fallbackLocale: Locale('ru'),
      supportedLocales: [
        const Locale('en'),
        const Locale('ru'),
        const Locale('kk'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'SalSat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: '/login',
      // getPages: [
      //   GetPage(
      //     name: '/login',
      //     page: () => LoginScreen(),
      //   ),
      // ],
      home:AnimatedSplashScreen(
        splash: 
          Container(
            child: SingleChildScrollView(
              child:
              Center(child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image.asset('assets/images/shop.png',width: 80,height: 80,),
              SizedBox(height: 16),
              Text('SalSat',
              textAlign: TextAlign.center,
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black),
              ), 
     
              ],
            )),
          )
          ),
        
        // Image.asset('assets/images/shop.png'), // замените на свое изображение для SplashScreen
        nextScreen: LoginScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
        duration: 1000, // продолжительность анимации SplashScreen
      ),
    );
  }
}
