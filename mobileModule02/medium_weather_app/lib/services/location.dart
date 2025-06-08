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
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  /// Checks and requests location permissions
  static Future<bool> _checkLocationPermission() async {
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }
}
