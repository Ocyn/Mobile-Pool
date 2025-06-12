import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherService {
  static Future<WeatherFactory?> initWeatherService(String _APIKEY) async {
    if (_APIKEY.isEmpty) {
      throw Exception('Weather API key not found');
    }

    try {
      WeatherFactory wf = WeatherFactory(_APIKEY, language: Language.FRENCH);
      return wf;
    } catch (e) {
      // Log error appropriately
      return null;
    }
  }

  static Future<Weather?> getWeatherByCoords(
    double lat,
    double lon,
    WeatherFactory wf,
  ) async {
    try {
      Weather w = await wf.currentWeatherByLocation(lat, lon);
      return w;
    } catch (e) {
      // Log error appropriately
      return null;
    }
  }

  static Future<Weather?> getWeatherByCity(
    String cityName,
    WeatherFactory wf,
  ) async {
    try {
      Weather w = await wf.currentWeatherByCityName(cityName);
      return w;
    } catch (e) {
      // Log error appropriately
      return null;
    }
  }
}
