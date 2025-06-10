import 'package:geocoding/geocoding.dart';
import 'package:open_meteo/open_meteo.dart';

class LocationSuggestion {
  final String city;
  final String region;
  final String country;
  final double lat;
  final double lon;

  LocationSuggestion({
    required this.city,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });

  @override
  String toString() {
    return '$city, $region, $country';
  }
}

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

  // Get location research suggestion
  static Future<List<LocationSuggestion>> getSuggestions(
    String input,
    int maxSuggestions,
  ) async {
    try {
      List<Location> locations = await locationFromAddress(input);
      List<LocationSuggestion> suggestions = [];
      int count = 0;
      for (Location location in locations) {
        if (count >= maxSuggestions) break;
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );
          if (placemarks.isNotEmpty) {
            Placemark placemark = placemarks.first;
            suggestions.add(
              LocationSuggestion(
                city:
                    placemark.locality ??
                    placemark.subAdministrativeArea ??
                    'Unknown',
                region: placemark.administrativeArea ?? 'Unknown',
                country: placemark.country ?? 'Unknown',
                lat: location.latitude,
                lon: location.longitude,
              ),
            );
            count++;
          }
        } catch (e) {
          continue;
        }
      }
      print('Found ${suggestions.length} suggestions for "$input":');
      for (LocationSuggestion suggestion in suggestions) {
        print(
          '  ${suggestion.toString()} (${suggestion.lat}, ${suggestion.lon})',
        );
      }
      return suggestions;
    } catch (e) {
      throw Exception('Failed to get suggestions: [$e]');
    }
  }
}
