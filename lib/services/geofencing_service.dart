import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GeofencingService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static bool isMonitoring = false;
  static Set<String> insideGeofences = {};
  static List<Map<String, dynamic>> geofencingLocations = [];

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

  static Future<void> loadGeofencingLocations() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('geofencing_locations')
          .where('active', isEqualTo: true)
          .get();

      geofencingLocations = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'],
          'lat': (data['lat'] as num).toDouble(),
          'lng': (data['lng'] as num).toDouble(),
          'radius': (data['radius'] as num).toDouble(),
        };
      }).toList();

      print("Loaded ${geofencingLocations.length} geofences.");
    } catch (error) {
      print("Error loading geofences: $error");
    }
  }

  static Future<void> startMonitoring() async {
    if (isMonitoring) return;
    isMonitoring = true;

    await loadGeofencingLocations();

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
          double radius = location['radius'];

          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            targetLat,
            targetLng,
          );

          bool currentlyInside = distance < radius;

          if (currentlyInside && !insideGeofences.contains(name)) {
            insideGeofences.add(name);
            _showNotification(
              "Nearby Donation Box",
              "You are near $name. Check the location and start donating!",
            );
          } else if (!currentlyInside && insideGeofences.contains(name)) {
            insideGeofences.remove(name);
            _showNotification(
              "Nearby Donation Box",
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
