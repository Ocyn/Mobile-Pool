import 'package:geocoding/geocoding.dart';

class GeocodingService {
  static Future<List<Location>> getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      return locations;
    } catch (e) {
      throw Exception('Failed to get location from address: $e');
    }
  }

  static Future<List<Placemark>> getPlacemarkFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      return placemarks;
    } catch (e) {
      throw Exception('Failed to get placemark from coordinates: $e');
    }
  }
}
