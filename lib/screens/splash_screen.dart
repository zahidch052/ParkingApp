import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkingapp/screens/parking_spots_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _askPermissions();
    super.initState();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getLocationPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Position position = await Geolocator.getCurrentPosition();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MapScreen(position.latitude, position.longitude),
        ),
      );
    } else {
      _handleInvalidPermissions(permissionStatus, 'contact');
    }
  }

  Future<PermissionStatus> _getLocationPermission() async {
    PermissionStatus permission = await Permission.location.request();
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.location.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(
      PermissionStatus permissionStatus, String name) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar =
          SnackBar(content: Text('Access to Location data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Location data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
