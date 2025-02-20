/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:recloth_x/utils/theme/widgets/customappBar/appBar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/widgets/container/header_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _initializeNotificationListeners();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        _username = userData.data()?['username'] as String?;
      });
    }
  }

  void _initializeNotificationListeners() {
    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Foreground notification received: ${message.notification!.title}");
        _showNotificationDialog(
          title: message.notification!.title ?? "Notification",
          body: message.notification!.body ?? "No body available",
        );
      }
    });

    // Handle when the user taps on a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification tapped: ${message.notification?.title}");
      // Navigate or perform specific actions here
    });

    // Handle notifications received when the app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("Notification caused app launch: ${message.notification?.title}");
        // Handle navigation or actions here
      }
    });
  }

  void _showNotificationDialog({required String title, required String body}) {
    showDialog(
      context: context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HeaderContainer(
              child: Column(
                children: [
                  SizedBox(
                      height:
                      kToolbarHeight + MediaQuery.of(context).padding.top),
                ],
              ),
            ),
          ),

          RAppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: RSizes.spaceBtwSections / 2),
                Text(RTexts.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: RColors.grey)),
                Text(_username ?? RTexts.homeAppbarSubTitle, style: Theme.of(context).textTheme.headlineMedium!.apply(color: RColors.white)),
              ],
            ),
          ),

          ///content
          Positioned.fill(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
            child: SingleChildScrollView(
              child: Column(
                children: [

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 */