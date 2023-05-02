import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language'.tr),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title: Text("English"),
              onTap: () {
                Get.updateLocale(Locale('en'));
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("Русский"),
              onTap: () {
                Get.updateLocale(Locale('ru'));
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("Қазақша"),
              onTap: () {
                Get.updateLocale(Locale('kk'));
              },
            )
          ],
        ),
      ),
    );
  }
}
