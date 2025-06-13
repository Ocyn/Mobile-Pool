import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:open_meteo/open_meteo.dart';

Map<double, String> weatherCodeStrings = {
  0: "Clear",
  1: "Mostly Clear",
  2: "Partly Cloudy",
  3: "Cloudy",
  45: "Fog",
  48: "Freezing Fog",
  51: "Light Drizzle",
  53: "Drizzle",
  55: "Heavy Drizzle",
  56: "Light Freezing Drizzle",
  57: "Freezing Drizzle",
  61: "Light Rain",
  63: "Rain",
  65: "Heavy Rain",
  66: "Light Freezing Rain",
  67: "Freezing Rain",
  71: "Light Snow",
  73: "Snow",
  75: "Heavy Snow",
  77: "Snow Grains",
  80: "Light Rain Shower",
  81: "Rain Shower",
  82: "Heavy Rain Shower",
  85: "Snow Shower",
  86: "Heavy Snow Shower",
  95: "Thunderstorm",
  96: "Hailstorm",
  99: "Heavy Hailstorm",
};

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

  static Future<Map<String, dynamic>> getWeather2(
    double lat,
    double lon,
  ) async {
    final results = (await WeatherApi().requestJson(
      latitude: lat,
      longitude: lon,
      hourly: {
        WeatherHourly.temperature_2m,
        WeatherHourly.wind_speed_10m,
        WeatherHourly.weather_code,
      },
    ));
    if (results.isEmpty) {
      throw Exception("getWeather2 error");
    }
    // Extraction des données hourly uniquement
    Map<String, dynamic> hourlyData = results['hourly'] ?? {};

    // Conversion sécurisée des times (peuvent être int ou String)
    List<String> times =
        (hourlyData['time'] as List?)
            ?.map((time) => time.toString())
            .toList() ??
        [];

    List<double> temperatures =
        (hourlyData['temperature_2m'] as List?)
            ?.map((temp) => temp?.toDouble() ?? 0.0)
            .cast<double>()
            .toList() ??
        <double>[];
    List<double> windSpeeds =
        (hourlyData['wind_speed_10m'] as List?)
            ?.map((speed) => speed?.toDouble() ?? 0.0)
            .cast<double>()
            .toList() ??
        <double>[];
    List<int> weatherCodes =
        (hourlyData['weather_code'] as List?)
            ?.map((code) => code?.toInt() ?? 0)
            .cast<int>()
            .toList() ??
        <int>[];

    print('Times: ${times.take(3)}...');
    print('Temperatures: ${temperatures.take(3)}...');
    print('Wind speeds: ${windSpeeds.take(3)}...');
    print('Weather codes: ${weatherCodes.take(3)}...');
    return hourlyData;
  }
}
