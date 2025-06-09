import 'package:location/location.dart';

class LocationService {
  static final Location _location = Location();

  /// Gets the current location coordinates
  static Future<LocationData?> getCurrentLocation() async {
    try {
      if (!await _checkLocationService()) return null;
      if (!await _checkLocationPermission()) return null;

      return await _location.getLocation();
    } catch (e) {
      return null;
    }
  }

  /// Gets latitude and longitude as a simple map
  static Future<Map<String, double>?> getCurrentCoordinates() async {
    final locationData = await getCurrentLocation();
    if (locationData == null) return null;

    return {
      'latitude': locationData.latitude ?? 0.0,
      'longitude': locationData.longitude ?? 0.0,
    };
  }

  /// Checks if location services are enabled
  static Future<bool> _checkLocationService() async {
    print('Checking location service...');
    bool serviceEnabled = await _location.serviceEnabled();
    print('Location service enabled: $serviceEnabled');
    if (!serviceEnabled) {
      print('Requesting location service...');
      serviceEnabled = await _location.requestService();
      print('Location service request result: $serviceEnabled');
    }
    return serviceEnabled;
  }

  /// Checks and requests location permissions
  static Future<bool> _checkLocationPermission() async {
    print('Checking location permission...');
    PermissionStatus permissionGranted = await _location.hasPermission();
    print('Current permission status: $permissionGranted');
    if (permissionGranted == PermissionStatus.denied) {
      print('Requesting location permission...');
      permissionGranted = await _location.requestPermission();
      print('Permission request result: $permissionGranted');
    }
    return permissionGranted == PermissionStatus.granted;
  }
}
