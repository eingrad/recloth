import 'package:geolocator/geolocator.dart';

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