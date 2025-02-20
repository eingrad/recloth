import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../data/models/user.dart';
import '../../../services/auth_service.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../constants/text_strings.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.firstnameController,
    required this.lastnameController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.dark,
  });

  final TextEditingController firstnameController;
  final TextEditingController lastnameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool dark;

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              /// Firstname
              Expanded(
                child: TextFormField(
                  controller: widget.firstnameController,
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: RTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: RSizes.spaceBtwInputFields),

              /// Lastname
              Expanded(
                child: TextFormField(
                  controller: widget.lastnameController,
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: RTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: RSizes.spaceBtwInputFields),

          /// Username
          TextFormField(
            controller: widget.usernameController,
            expands: false,
            decoration: const InputDecoration(
              labelText: RTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: RSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: widget.emailController,
            decoration: const InputDecoration(
              labelText: RTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: RSizes.spaceBtwInputFields),

          /// Password with Toggle Visibility
          TextFormField(
            controller: widget.passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: RTexts.password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: RSizes.spaceBtwInputFields),

          /// Terms & Conditions
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(value: true, onChanged: (value) {}),
              ),
              const SizedBox(width: RSizes.spaceBtwItems),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${RTexts.iAgreeTo} ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: RTexts.privacyPolicy,
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                          color: widget.dark ? RColors.white : RColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: ' ${RTexts.and} ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: RTexts.termsOfUse,
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                          color: widget.dark ? RColors.white : RColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: RSizes.spaceBtwInputFields),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final userCredential = await AuthService().signup(
                    email: widget.emailController.text,
                    password: widget.passwordController.text,
                    context: context,
                  );

                  final userId = userCredential?.user?.uid;

                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signup failed. Please try again.'),
                      ),
                    );
                    return;
                  }

                  final userData = UserData(
                    firstname: widget.firstnameController.text,
                    lastname: widget.lastnameController.text,
                    username: widget.usernameController.text,
                    uid: userId,
                  );

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .set(userData.toMap());

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account created successfully!'),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {

                }
              },
              child: const Text(RTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
