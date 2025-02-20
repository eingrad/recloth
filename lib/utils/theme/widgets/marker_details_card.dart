import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../helpers/helper_functions.dart';

class MarkerDetailsCard extends StatelessWidget {
  final Map<String, dynamic> markerData;

  const MarkerDetailsCard({super.key, required this.markerData});

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          _buildHeader(context, dark),
          _buildDetails(context, dark),
          Positioned(
            top: 25,
            right: 14,
            child: Image.asset('assets/box.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool dark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: RColors.black.withAlpha(150),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, spreadRadius: 1, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            markerData['title'] ?? 'Unknown Title',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            markerData['snippet'] ?? 'No details available',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context, bool dark) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: dark ? Colors.black54 : Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Item",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.black),
            ),
            _buildFeatures(markerData['item'], dark),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures(List<dynamic>? features, bool dark) {
    if (features == null || features.isEmpty) {
      return const Center(child: Text('No features available'));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: features.map((feature) {
        return _buildFeatureItem(feature['icon'], feature['label'], feature['detail'], dark);
      }).toList(),
    );
  }

  Widget _buildFeatureItem(IconData? icon, String? label, String? detail, bool dark) {
    return Container(
      width: 100,
      height: 110,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dark ? Colors.white54 : Colors.black54, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          Text(label ?? ''),
          Text(
            detail ?? '',
            style: TextStyle(color: dark ? Colors.white54 : Colors.black54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
