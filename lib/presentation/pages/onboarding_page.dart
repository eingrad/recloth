import 'package:flutter/material.dart';
import 'package:recloth_x/utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);
    final textColor = dark ? RColors.white : RColors.black;
    final backgroundColor = dark ? RColors.black : Colors.white;
    final buttonTextColor = dark ? RColors.white : Colors.white;
    final buttonBackgroundColor = dark ? RColors.orange : RColors.orange;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/onboarding 2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'ReClothe Application \nMake donation easy',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'No worries about where your donation.\nIt Always for those in need',
                  style: TextStyle(
                    color: dark ? Colors.grey[400] : Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 320,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: buttonTextColor,
                      backgroundColor: buttonBackgroundColor,
                    ),
                    child: Text(
                      'Let\'s Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}