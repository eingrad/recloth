import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/colors.dart';

class MapActionButtons extends StatelessWidget {
  final GoogleMapController controller;
  final Future<Position> Function() getCurrentPosition;
  final Set<Marker> markers;
  final Function updateMarkers;
  final double iconSize;

  const MapActionButtons({
    super.key,
    required this.controller,
    required this.getCurrentPosition,
    required this.markers,
    required this.updateMarkers,
    this.iconSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Zoom In Button
          _buildActionButton(
            Icons.zoom_in,
                () {
              controller.animateCamera(CameraUpdate.zoomIn());
            },
          ),
          const SizedBox(width: 10),
          /// FindMyLocation button
          _buildActionButton(
            Icons.my_location,
                () async {
              Position position = await getCurrentPosition();
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          // Zoom Out Button
          _buildActionButton(
            Icons.zoom_out,
                () {
              controller.animateCamera(CameraUpdate.zoomOut());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return FloatingActionButton(
      backgroundColor: RColors.orange,
      onPressed: onPressed,
      child: Icon(icon, size: iconSize, color: Colors.white),
    );
  }
}