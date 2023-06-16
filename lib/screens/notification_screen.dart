// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/firebase_messaging_controller.dart';

class NotificationScreen extends StatelessWidget {
  final FirebaseMessagingController _firebaseMessagingController = Get.put(FirebaseMessagingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<FirebaseMessagingController>(
        builder: (controller) {
          final notifications = controller.notifications;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.asset(notifications[index]['image']!),
                title: Text(notifications[index]['title']!),
                subtitle: Text(notifications[index]['content']!),
              );
            },
          );
        },
      ),
    );
  }
}
