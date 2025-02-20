import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class LoginFormDivider extends StatelessWidget {
  const LoginFormDivider({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider(color: dark ? RColors.grey: RColors.grey, thickness: 1, indent: 60, endIndent: 5)),

        Flexible(child: Divider(color: dark ? RColors.grey: RColors.grey, thickness: 1, indent: 5, endIndent: 60)),
      ],
    );
  }
}





///Text(RTexts.orSignInWith.capitalize!, style: Theme.of(context).textTheme.labelMedium),