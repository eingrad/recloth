import 'package:flutter/material.dart';
import 'package:recloth_x/utils/helpers/helper_functions.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(RSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              Text(RTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: RSizes.spaceBtwInputFields),

              ///Form
              SignupForm(firstnameController: _firstnameController, lastnameController: _lastnameController, usernameController: _usernameController, emailController: _emailController, passwordController: _passwordController, dark: dark),
            ],
          ),
        ),
      ),
    );

  }
}


