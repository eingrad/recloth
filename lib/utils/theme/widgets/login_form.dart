import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recloth_x/services/auth_service.dart';
import '../../../presentation/pages/signup.dart';
import '../../constants/sizes.dart';
import '../../constants/text_strings.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: RSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email Input
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: RTexts.email,
              ),
            ),
            const SizedBox(height: RSizes.spaceBtwInputFields),

            /// Password Input with Toggle Visibility
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: RTexts.password,
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
            const SizedBox(height: RSizes.spaceBtwInputFields / 2),

            const SizedBox(height: RSizes.spaceBtwSections / 2),

            /// Sign-in Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await AuthService().signin(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context,
                  );
                },
                child: Text(RTexts.signIn),
              ),
            ),
            const SizedBox(height: RSizes.spaceBtwSections / 2),

            /// Sign-up Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text(RTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///Remember Me
/*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                ///Forget Pass
                TextButton(onPressed: (){}, child: const Text(RTexts.forgetPassword)),
              ],
            ),*/