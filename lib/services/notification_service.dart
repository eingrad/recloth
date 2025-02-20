import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotificationDialog(
        title: message.notification?.title ?? "Notification",
        body: message.notification?.body ?? "No body available",
      );
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.notification?.title}');
      _navigateToTargetScreen(message);
    });

    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _navigateToTargetScreen(initialMessage);
    }
  }

  static void _showNotificationDialog({required String title, required String body}) {
    if (navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  static void _navigateToTargetScreen(RemoteMessage message) {
    if (message.data['route'] != null) {
      navigatorKey.currentState?.pushNamed(message.data['route']);
    }
  }
}
