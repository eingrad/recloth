/*import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recloth_x/utils/constants/text_strings.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng myCurrentLocation = const LatLng(3.073281, 101.518461);
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    customMarker();
    super.initState();
  }

  /// Custom marker
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  void customMarker() {
    BitmapDescriptor.asset(ImageConfiguration(), "assets/marker1.png").then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

  /// Helper method to add a marker
  void _addMarker(LatLng position, {String title = "Custom Marker"}) {
    final markerId = MarkerId('marker_${position.latitude}_${position.longitude}');
    final newMarker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: "Lat: ${position.latitude}, Lng: ${position.longitude}",
      ),
      icon: customIcon,
      draggable: true,
      onDragEnd: (newPosition) {
        debugPrint("Marker dragged to: $newPosition");
      },
    );

    setState(() {
      markers.add(newMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.map),
            Text(
              RTexts.maps,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 14,
        ),
        onTap: (LatLng tappedPosition) {
          _addMarker(tappedPosition); // Add a marker on map tap
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          size: 30,
        ),
        onPressed: () async {
          Position position = await currentPosition();

          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14,
              ),
            ),
          );

          _addMarker(LatLng(position.latitude, position.longitude), title: "Current Location");
        },
      ),
    );
  }

  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Checking if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    // Checking the location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Requesting permission if it is denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    // Handling the case where permission is permanently denied
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // Getting the current position of the user
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}*/