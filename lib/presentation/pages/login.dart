import 'package:flutter/material.dart';
import 'package:recloth_x/utils/constants/spacing_styles.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../utils/theme/widgets/login_form.dart';
import '../../utils/theme/widgets/login_form_divider.dart';
import '../../utils/theme/widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: RSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, title & Sub
               LoginHeader(dark: dark),

              ///Form
               LoginForm(),

              ///divider
              LoginFormDivider(dark: dark)
            ],
          ),
        ),
      ),
    );
  }
}





