import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:recloth_x/presentation/pages/login.dart';
import 'package:recloth_x/utils/theme/widgets/navigation_menu.dart';
import 'package:recloth_x/services/geofencing_service.dart';

class AuthService {
  Future<UserCredential?> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An unexpected error occurred. Please try again.';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password is too weak. Please use a stronger one.';
          break;
        case 'email-already-in-use':
          errorMessage = 'This email is already registered. Try logging in.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format. Please enter a correct email.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'Please fill in all required fields';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
      return null;
    }

    if (userCredential == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create user. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
      return null;
    }

    return userCredential;
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email and password."),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Get the FCM token
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        if (fcmToken != null) {
          // Save the FCM token to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'fcm_token': fcmToken,
          });
          print('FCM token updated successfully for user: ${user.uid}');
        } else {
          print('Failed to get FCM token');
        }

        // Start Geofencing
        await GeofencingService.startMonitoring();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationMenu()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'user-not-found') {
        message = 'No user found with this email. Please check and try again.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format. Please enter a valid email.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many failed attempts. Please try again later.';
      } else {
        message = 'Incorrect password. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      print("Login error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred: $e"),
        ),
      );
    }
  }


  Future<void> signout({
    required BuildContext context
  }) async {
    await FirebaseAuth.instance.signOut();

    await GeofencingService.stopMonitoring();

    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()
        )
    );
  }
}
