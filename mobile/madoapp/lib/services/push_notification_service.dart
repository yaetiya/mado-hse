import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:madoapp/api/push_notification_api.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotificationService {
  static late FirebaseMessaging messaging;
  static isAllow() async => await Permission.notification.isGranted;
  static Future<void> requestNotifications() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      await init();
    }
  }

  static init() async {
    if (!await isAllow()) {
      return;
    }
    messaging = FirebaseMessaging.instance;
    messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fcmToken = await messaging.getToken();
    if (fcmToken == null) return;
    return PushNotificationApi.sendToken(fcmToken);
  }
}
