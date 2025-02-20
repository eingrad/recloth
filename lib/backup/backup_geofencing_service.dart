/*
*
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GeofencingService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static bool isMonitoring = false;

  static Set<String> insideGeofences = {};

  static final List<Map<String, dynamic>> geofencingLocations = [
    {'name': 'Donation Box 1', 'lat': 3.067362, 'lng': 101.501741, 'radius': 150.0},
    {'name': 'Donation Box 2', 'lat': 3.077281, 'lng': 101.528461, 'radius': 100.0},
    {'name': 'Donation Box 3', 'lat': 3.083281, 'lng': 101.538461, 'radius': 100.0},
  ];

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings =
    InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);

    await _checkLocationPermissions();
  }

  static Future<void> _checkLocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  }

  static Future<void> startMonitoring() async {
    if (isMonitoring) return;
    isMonitoring = true;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print("Current location: ${position.latitude}, ${position.longitude}");

      Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      ).listen((Position position) {
        if (!isMonitoring) return;

        for (var location in geofencingLocations) {
          String name = location['name'];
          double targetLat = location['lat'];
          double targetLng = location['lng'];
          double radius = (location['radius'] as num).toDouble();

          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            targetLat,
            targetLng,
          );

          bool currentlyInside = distance < radius;

          // ✅ Fix: Reference insideGeofences correctly
          if (currentlyInside && !insideGeofences.contains(name)) {
            insideGeofences.add(name);
            _showNotification(
              "Nearby Donation Box",
              "You are near $name. check the location and start donating",
            );
          } else if (!currentlyInside && insideGeofences.contains(name)) {
            insideGeofences.remove(name);
            _showNotification(
              "Nearby Donation box",
              "You have left $name donation area.",
            );
          }
        }
      });
    } catch (error) {
      print("Error initializing geofencing: $error");
    }
  }

  static Future<void> stopMonitoring() async {
    isMonitoring = false;
    insideGeofences.clear();
    print("Geofencing stopped.");
  }

  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'geofence_channel',
      'Geofence Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}

*
*/