// import 'package:sal_sat/generated/locale_keys.g.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sal_sat/views/change_lang_screen.dart';
import '../controllers/settings_controller.dart';
import '../service/settings_service.dart';
import 'change_theme_screen.dart';
// import 'package:easy_localization/easy_localization.dart';
// import  'package:easy_localization/src/public_ext.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController(SettingsService()));
    controller.loadSettings();
    return Scaffold(
        appBar: AppBar(
          actions: [
            // IconButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
                
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ListTile(
              title: Text('Personal_settings'.tr),
              leading: Icon(Icons.person),
            ),
               Divider()
            ,
            ListTile(
              title: Text('Language'.tr),
              leading: Icon(Icons.language),
              onTap:(){
                Get.back();
                Get.to(() => ChangeLanguageScreen());
              },
            ),
               Divider()
            ,
            ListTile(
              title: Text('Theme'.tr),
              leading: Icon(Icons.dark_mode),
              onTap:(){
                Get.back();
                Get.to(() => ChangeThemeScreen(controller: controller));
              },
            ),
          ],
        ));
  }
}
