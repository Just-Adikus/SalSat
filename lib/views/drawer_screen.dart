// import 'package:sal_sat/generated/locale_keys.g.dart';
import 'package:sal_sat/views/favourite_screen.dart';

import '/controllers/data_controller.dart';
import '/views/login_user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:easy_localization/easy_localization.dart';
// import  'package:easy_localization/src/public_ext.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final DataController controller = Get.find();
    void _logOut() {
    controller.clearUserData();
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    // var controller;
    return SafeArea(
      child: Container(
        width: 220,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${'User'.tr}: ${controller.userProfileData['userName']}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    FittedBox(
                      child: Text(
                        '${'Join_Date'.tr} :${DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(controller.userProfileData['joinDate']))} ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title:  Text('Your_Product'.tr),
                onTap: () {
                  Get.back();
                  Get.to(() => LoginUserProductScreen());
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title:  Text('Favourites'.tr),
                onTap: () {
                  Get.back();
                  Get.to(() => FavoritesScreen());
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'.tr),
                onTap: () {
                  Get.back();
                  Get.to(() => SettingsScreen());
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('LogOut'.tr),
                onTap: () {
                        Get.back();
                        // // Clear the user data from the controller
                        // controller.clearUserData();
                        // Navigate to the login screen
                        Get.to(() => LoginScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
