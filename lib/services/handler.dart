import 'package:permission_handler/permission_handler.dart';


Future<void> requestPermissions() async {
  if (await Permission.location.request().isGranted) {
    // Permission granted
  } else {
    // Handle denial
  }
}