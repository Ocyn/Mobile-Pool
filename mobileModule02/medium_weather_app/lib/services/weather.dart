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
      return null;
    }
  }

  static Future<Map<String, List<dynamic>>> getWeatherHourly(
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
    Map<String, dynamic> hourlyData = results['hourly'] ?? {};

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
    List<String> weatherCodes =
        (hourlyData['weather_code'] as List?)
            ?.map((code) => weatherCodeStrings[code?.toDouble()] ?? 'Unknown')
            .toList() ??
        <String>[];

    print('Times: ${times.take(3)}...');
    print('Temperatures: ${temperatures.take(3)}...');
    print('Wind speeds: ${windSpeeds.take(3)}...');
    print('Weather codes: ${weatherCodes.take(3)}...');

    return {
      'times': times,
      'temperatures': temperatures,
      'wind_speeds': windSpeeds,
      'weather_codes': weatherCodes,
    };
  }

  static Future<Map<String, dynamic>> getCurrentWeather(
    double lat,
    double lon,
  ) async {
    final results = await WeatherApi().requestJson(
      latitude: lat,
      longitude: lon,
      current: {
        WeatherCurrent.temperature_2m,
        WeatherCurrent.weather_code,
        WeatherCurrent.wind_speed_10m,
      },
    );

    if (results.isEmpty) {
      throw Exception("getCurrentWeather error");
    }

    Map<String, dynamic> currentData = results['current'] ?? {};

    return {
      'time': currentData['time'] ?? '',
      'temperature': currentData['temperature_2m']?.toDouble() ?? 0.0,
      'weather_code':
          weatherCodeStrings[currentData['weather_code']?.toDouble()] ??
          'Unknown',
      'wind_speed': currentData['wind_speed_10m']?.toDouble() ?? 0.0,
    };
  }

  static Future<Map<String, List<dynamic>>> getTodayWeather(
    double lat,
    double lon,
  ) async {
    final results = await WeatherApi().requestJson(
      latitude: lat,
      longitude: lon,
      hourly: {
        WeatherHourly.temperature_2m,
        WeatherHourly.weather_code,
        WeatherHourly.wind_speed_10m,
      },
    );

    if (results.isEmpty) {
      throw Exception("getTodayWeather error");
    }

    Map<String, dynamic> hourlyData = results['hourly'] ?? {};

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

    List<String> weatherCodes =
        (hourlyData['weather_code'] as List?)
            ?.map((code) => weatherCodeStrings[code?.toDouble()] ?? 'Unknown')
            .toList() ??
        <String>[];

    List<double> windSpeeds =
        (hourlyData['wind_speed_10m'] as List?)
            ?.map((speed) => speed?.toDouble() ?? 0.0)
            .cast<double>()
            .toList() ??
        <double>[];

    return {
      'times': times,
      'temperatures': temperatures,
      'weather_codes': weatherCodes,
      'wind_speeds': windSpeeds,
    };
  }

  static Future<Map<String, List<dynamic>>> getWeeklyWeather(
    double lat,
    double lon,
  ) async {
    final results = await WeatherApi().requestJson(
      latitude: lat,
      longitude: lon,
      daily: {
        WeatherDaily.weather_code,
        WeatherDaily.temperature_2m_max,
        WeatherDaily.temperature_2m_min,
        WeatherDaily.wind_speed_10m_max,
      },
    );

    if (results.isEmpty) {
      throw Exception("getWeeklyWeather error");
    }

    Map<String, dynamic> dailyData = results['daily'] ?? {};

    List<String> times =
        (dailyData['time'] as List?)?.map((time) => time.toString()).toList() ??
        [];

    List<String> weatherCodes =
        (dailyData['weather_code'] as List?)
            ?.map((code) => weatherCodeStrings[code?.toDouble()] ?? 'Unknown')
            .toList() ??
        <String>[];

    List<double> temperatureMax =
        (dailyData['temperature_2m_max'] as List?)
            ?.map((temp) => temp?.toDouble() ?? 0.0)
            .cast<double>()
            .toList() ??
        <double>[];

    List<double> temperatureMin =
        (dailyData['temperature_2m_min'] as List?)
            ?.map((temp) => temp?.toDouble() ?? 0.0)
            .cast<double>()
            .toList() ??
        <double>[];

    List<double> windSpeedMax =
        (dailyData['wind_speed_10m_max'] as List?)
            ?.map((speed) => speed?.toDouble() ?? 0.0)
            .cast<double>()
            .toList() ??
        <double>[];

    return {
      'times': times,
      'weather_codes': weatherCodes,
      'temperature_max': temperatureMax,
      'temperature_min': temperatureMin,
      'wind_speed_max': windSpeedMax,
    };
  }
}
