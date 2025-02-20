import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recloth_x/presentation/pages/campaign_list.dart';
import 'package:recloth_x/presentation/pages/home_new.dart';
import 'package:recloth_x/presentation/pages/setting_screen.dart';
import 'package:recloth_x/utils/helpers/helper_functions.dart';
import '../../../presentation/pages/map_screen.dart';
import '../../constants/colors.dart';

class NavigationMenu extends StatelessWidget{
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = RHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? RColors.black : Colors.white,
          indicatorColor: darkMode
              ? RColors.white.withAlpha((255 * 0.1).toInt())
              : RColors.black.withAlpha((255 * 0.1).toInt()),

          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.lovely), label: 'Donate'),
            NavigationDestination(icon: Icon(Iconsax.map), label: 'Find Box'),
            NavigationDestination(icon: Icon(Iconsax.setting), label: 'Setting'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const CampaignScreen(),
    const MapScreen(),
    const SettingScreen(),
  ];
}