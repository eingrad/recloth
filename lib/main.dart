import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recloth_x/firebase_options.dart';
import 'package:recloth_x/presentation/pages/login.dart';
import 'package:recloth_x/presentation/pages/onboarding_page.dart';
import 'package:recloth_x/services/notification_service.dart';
import 'package:recloth_x/utils/constants/text_strings.dart';
import 'package:recloth_x/utils/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'controller/dark_mode_controller.dart';
import 'services/geofencing_service.dart';

// Background message handler for Firebase
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register Firebase background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize NotificationService
  await NotificationService.initialize();

  // Register Dark Mode Controller
  Get.put(DarkModeController());

  // Start Geofencing
  await GeofencingService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: RTexts.appName,
      navigatorKey: NotificationService.navigatorKey,
      themeMode: ThemeMode.system,
      theme: RAppTheme.lightTheme,
      darkTheme: RAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
      ],
      home: OnboardingPage(),
    );
  }
}
