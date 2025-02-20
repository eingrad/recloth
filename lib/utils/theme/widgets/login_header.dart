import 'package:flutter/material.dart';
import '../../constants/image_strings.dart';
import '../../constants/sizes.dart';
import '../../constants/text_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height:150,
          image: AssetImage(dark ? RImages.lightAppLogo : RImages.darkAppLogo),
        ),
        Text(RTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: RSizes.sm),
        Text(RTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}