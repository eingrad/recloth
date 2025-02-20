import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recloth_x/services/auth_service.dart';

import '../../controller/dark_mode_controller.dart';
import 'edit_profile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? _username;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => DarkModeController());
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(
          uid).get();
      setState(() {
        _username = userData.data()?['username'] as String?;
        _photoUrl = userData.data()?['photoUrl'] as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.setting),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
                    ? NetworkImage(_photoUrl!)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            // Name and Joined Info
            Center(
              child: Column(
                children: [
                  Text(
                    _username ?? 'loading...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 30),
                  // Profile Section
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(
                            10),
                      ),
                      child: const Icon(Icons.person, color: Colors.orange),
                    ),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(uid: user.uid),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Settings Section
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.dark_mode, color: Colors.blue),
                    ),
                    title: const Text('Dark Mode'),
                    trailing: SizedBox(
                      width: 50,
                      child: Obx(() {
                        final darkModeController = Get.find<
                            DarkModeController>();
                        return Switch(
                          value: darkModeController.isDarkMode.value,
                          onChanged: (value) {
                            darkModeController.toggleDarkMode();
                          },
                          activeColor: Colors.orangeAccent,
                          activeTrackColor: Colors.orange.shade100,
                          inactiveThumbColor: Colors.grey.shade300,
                          inactiveTrackColor: Colors.grey.shade400,
                        );
                      }),
                    ),
                  ),
                  const Spacer(),
                  // Sign Out Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await AuthService().signout(context: context);
                      },
                      child: const Text('Sign Out'),
                    ),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
