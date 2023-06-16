import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';


class FirebaseMessagingController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Map<String, String>> notifications = [];

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print('Firebase Messaging Token: $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle notification when received inside the app
      print('Received message within the app: ${message.notification?.title}');
      saveNotification(message.notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification when the app is opened from a notification
      print('Opened app from notification: ${message.notification?.title}');
      saveNotification(message.notification);
    });
  }

  void saveNotification(RemoteNotification? notification) {
    final newNotification = {
      'image': 'assets/shop.png',
      'title': notification?.title ?? '',
      'content': notification?.body ?? '',
    };

    notifications.add(newNotification);
    update(); // Update the GetX listener to rebuild the UI
  }
}

