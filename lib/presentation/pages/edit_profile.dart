import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;

  const EditProfileScreen({super.key, required this.uid});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final email = user.email;

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          if (!mounted) return;

          setState(() {
            _usernameController.text = userData['username'] ?? '';
            _emailController.text = email ?? 'No email available';
            _addressController.text = userData['address'] ?? '';
            _userPhotoUrl = userData['photoUrl'] ?? '';
          });
        } else {
          debugPrint('No user document found in Firestore!');
        }
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> _selectAndUploadPicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${widget.uid}.jpg');

        final snapshot = await storageRef.putFile(file);

        if (!mounted) return;

        final photoUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({'photoUrl': photoUrl});

        if (!mounted) return;

        setState(() {
          _userPhotoUrl = photoUrl;
        });

        _showSnackBar('Profile picture updated successfully!');
      } else {
        _showSnackBar('No image selected.');
      }
    } catch (e) {
      debugPrint('Error uploading picture: $e');
      _showSnackBar('Failed to upload picture.');
    }
  }

  Future<void> _updateUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final currentEmail = user.email;

        if (currentEmail != null && _currentPasswordController.text.isNotEmpty) {
          try {
            final credential = EmailAuthProvider.credential(
              email: currentEmail,
              password: _currentPasswordController.text,
            );

            await user.reauthenticateWithCredential(credential);
          } on FirebaseAuthException {
            _showSnackBar('Invalid credentials. Please check your current password.');
            return;
          }

          // If the user wants to update their email
          if (_emailController.text.isNotEmpty && _emailController.text != currentEmail) {
            try {
              await user.verifyBeforeUpdateEmail(_emailController.text);
              _showSnackBar('Verification email sent to ${_emailController.text}. Please verify your email before updating further.');

              // Exit the function here since the email update needs verification
              return;
            } on FirebaseAuthException catch (e) {
              if (e.code == 'invalid-email') {
                _showSnackBar('Invalid email format. Please check your input.');
              } else if (e.code == 'email-already-in-use') {
                _showSnackBar('The email is already in use by another account.');
              } else {
                _showSnackBar('Failed to update email. Error: ${e.message}');
              }
              return;
            }
          }

          // If the user wants to update their password
          if (_passwordController.text.isNotEmpty) {
            try {
              await user.updatePassword(_passwordController.text);
              _showSnackBar('Password updated successfully!');
            } on FirebaseAuthException {
              _showSnackBar('Password is too weak. Please use a stronger password.');
              return;
            }
          }
        }

        // Update other Firestore user data (like username and address)
        await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
          'username': _usernameController.text,
          'address': _addressController.text,
        });

        // Clear sensitive fields
        _currentPasswordController.clear();
        _passwordController.clear();

        // Refresh the username and email fields
        await _fetchUserData();

        _showSnackBar('Profile updated successfully!');
      }
    } catch (e) {
      debugPrint('Error updating user data: $e');
      _showSnackBar('Failed to update profile. Please check your inputs.');
    }
  }




  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.orangeAccent,
          child: Column(
            children: [
              Container(
                height: 150,
                color: Colors.orangeAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white54,
                      backgroundImage: _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                          ? NetworkImage(_userPhotoUrl!)
                          : null,
                      child: (_userPhotoUrl == null || _userPhotoUrl!.isEmpty)
                          ? Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      )
                          : null,
                    ),
                    TextButton(
                      onPressed: _selectAndUploadPicture,
                      child: Text(
                        'Change Picture',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    buildTextField('Username', _usernameController),
                    SizedBox(height: 15),
                    buildTextField('Email', _emailController),
                    SizedBox(height: 15),
                    buildTextField(
                      'New Password',
                      _passwordController,
                      isPassword: true,
                      hintText: 'Enter your new password',
                    ),
                    SizedBox(height: 15),
                    buildTextField(
                      'Current Password',
                      _currentPasswordController,
                      isPassword: true,
                    ),
                    SizedBox(height: 15),
                    buildMultilineTextField('Address', _addressController),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _updateUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText ?? 'Enter your $label',
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMultilineTextField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}