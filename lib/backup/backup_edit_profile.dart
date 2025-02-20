/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;

  const EditProfileScreen({super.key, required this.uid});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
        final email = user.email; // Get email from FirebaseAuth

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            _usernameController.text = userData['username'] ?? '';
            _emailController.text = email ?? 'No email available'; // Preserve email state
            _addressController.text = userData['address'] ?? '';
            _userPhotoUrl = userData['photoUrl'] ?? ''; // Preserve photo URL state
          });
        } else {
          print('No user document found in Firestore!');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _selectAndUploadPicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${widget.uid}.jpg');

        final uploadTask = storageRef.putFile(file);
        final snapshot = await uploadTask;

        // Get download URL
        final photoUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore with the photo URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({'photoUrl': photoUrl});

        // Fetch user data to ensure both email and photoUrl are up-to-date
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            _userPhotoUrl = photoUrl; // Update photo URL
            _emailController.text = userData['email'] ?? ''; // Preserve email state
            _usernameController.text = userData['username'] ?? '';
            _addressController.text = userData['address'] ?? '';
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      print('Error uploading picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload picture.')),
      );
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

            // Attempt to reauthenticate
            await user.reauthenticateWithCredential(credential);
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid credentials. Please check your current password.')),
            );
            return;
          }

          // Update email if changed
          if (_emailController.text.isNotEmpty && _emailController.text != currentEmail) {
            try {
              await user.verifyBeforeUpdateEmail(_emailController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Verification email sent. Please verify your email.')),
              );
              return; // Exit until verification
            } on FirebaseAuthException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid email format. Please check your input.')),
              );
              return;
            }
          }

          // Reload user to check email verification
          await user.reload();
          if (!user.emailVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please verify your email before proceeding.')),
            );
            return;
          }

          // Update password if it has changed
          if (_passwordController.text.isNotEmpty) {
            try {
              await user.updatePassword(_passwordController.text);
            } on FirebaseAuthException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password is too weak. Please use a stronger password.')),
              );
              return;
            }
          }
        }

        // Update Firestore user data
        await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
          'username': _usernameController.text,
          'address': _addressController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile. Please check your inputs.')),
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
                      backgroundColor: Colors.purpleAccent,
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
*/