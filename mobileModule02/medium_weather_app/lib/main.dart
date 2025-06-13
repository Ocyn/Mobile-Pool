import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather/weather.dart';
import 'services/weather.dart';
import 'services/geocoding.dart';
import 'services/location.dart';
import 'package:open_meteo/open_meteo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: DefaultTabController(
        length: 3,
        child: MyHomePage(title: 'Weather Report'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TabController _tabController;

  Map<String, double> coordinates = {'latitude': 0.0, 'longitude': 0.0};
  String _city = "";
  String _country = "";
  String _locationStatus = "awaiting...";
  String _searchCity = "";
  List<LocationSuggestion> suggestions = [];
  bool showSuggestions = false;

  String _errorMessage = "";
  bool _isLoadingSuggestions = false;

  Future<Map<String, List<dynamic>>>? _weatherFuture;

  void _updateSuggestions(List<LocationSuggestion> newSuggestions, bool show) {
    setState(() {
      suggestions = newSuggestions;
      // showSuggestions = show;
    });
  }

  Future<void> onPressedLocationButton() async {
    print("Location button pressed Searching current device location...");
    await _getlocation();
    setState(() {
      print("location: $_locationStatus");
      if (coordinates.isNotEmpty) {
        _searchCity = "City: $_city\nCountry: $_country";
      } else {
        _searchCity = _locationStatus;
      }
    });
    if (coordinates.isNotEmpty) {
      await WeatherService.getWeather2(
        coordinates['latitude']!,
        coordinates['longitude']!,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = DefaultTabController.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getlocation() async {
    try {
      final coords = await LocationService.getCurrentCoordinates();
      setState(() {
        if (coords != null) {
          coordinates = coords;
          _locationStatus =
              "Location found: [${coords['latitude']}, ${coords['longitude']}}]";
        } else {
          _locationStatus = "Unable to get current location";
          _errorMessage = "Unable to get current location";
        }
      });

      if (coords != null) {
        try {
          List<Placemark> placemarks =
              await GeocodingService.getPlacemarkFromCoordinates(
                coords['latitude']!,
                coords['longitude']!,
              );
          setState(() {
            if (placemarks.isNotEmpty) {
              _city = placemarks.first.locality ?? "City not found";
              _country = placemarks.first.country ?? "COuntry not found";
              _locationStatus += "\nCity: $_city, $_country";
            }
          });
        } catch (e) {
          setState(() {
            _locationStatus += "\nGeocoding error: $e";
            _errorMessage = "$e";
          });
        }
      }
    } catch (e) {
      setState(() {
        _locationStatus = "Error: $e";
        _errorMessage = "$e";
      });
    }
  }

  Future<void> _getSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        suggestions.clear();
        showSuggestions = false;
        _isLoadingSuggestions = false;
      });
      return;
    }

    setState(() {
      _isLoadingSuggestions = true;
      suggestions.clear();
    });

    try {
      Map<String, dynamic> results = (await GeocodingApi().requestJson(
        name: input,
        count: 5,
      ));

      if (results.isEmpty) throw Exception('error results is empty chakal');

      List<LocationSuggestion> newSuggestions = [];
      if (results.containsKey("results")) {
        List<dynamic> places = results['results'];
        for (var place in places) {
          Map<String, dynamic> p = place as Map<String, dynamic>;
          LocationSuggestion s = await LocationSuggestion.toLocationSuggestion(
            p,
          );
          newSuggestions.add(s);
        }
      }

      setState(() {
        suggestions = newSuggestions;
        showSuggestions = newSuggestions.isNotEmpty;
        _isLoadingSuggestions = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "getSuggestion error: $e";
        _isLoadingSuggestions = false;
        showSuggestions = false;
      });
    }
  }

  // Future<Weather?> _getWeather(String? city) async {
  //   WeatherFactory? weatherFactory = await WeatherService.initWeatherService(
  //     "2709c218504646cc4c3251759b90dda6",
  //   );

  //   if (weatherFactory == null || coordinates == null) {
  //     debugPrint("Error : WeatherFactory or coordinates null");
  //     return null;
  //   }

  //   double? latitude = coordinates!['latitude'];
  //   double? longitude = coordinates!['longitude'];

  //   if (latitude == null || longitude == null) {
  //     debugPrint("Error: Coordinates values null");
  //     return null;
  //   }
  //   late Weather? weather;
  //   if (city!.isNotEmpty) {
  //     weather = await WeatherService.getWeatherByCity(city, weatherFactory);
  //   } else {
  //     weather = await WeatherService.getWeatherByCoords(
  //       latitude,
  //       longitude,
  //       weatherFactory,
  //     );
  //   }
  //   if (weather != null) {
  //     debugPrint("Weather Data:");
  //     debugPrint("Temperature: ${weather.temperature?.celsius}°C");
  //     debugPrint("Feels Like: ${weather.tempFeelsLike?.celsius}°C");
  //     debugPrint("Humidity: ${weather.humidity}%");
  //     debugPrint("Pressure: ${weather.pressure}hPa");
  //     debugPrint("Wind Speed: ${weather.windSpeed}m/s");
  //   } else {
  //     debugPrint("Weather data is null");
  //   }
  //   return weather;
  // }

  Widget geoLocationButton() {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {
        setState(() {
          _locationStatus = "awaiting...";
          _searchCity = _locationStatus;
        });
        onPressedLocationButton();
      },
      child: Icon(Icons.location_on),
    );
  }

  Widget _buildSuggestionsListView() {
    return ListView.separated(
      itemBuilder: (context, index) {
        LocationSuggestion city = suggestions[index];
        return ListTile(
          title: Text(city.city),
          subtitle: Text('${city.country}, ${city.region}'),
          onTap: () async {
            setState(() {
              _searchCity = city.city;
              coordinates['latitude'] = city.lat;
              coordinates['longitude'] = city.lon;
              showSuggestions = false;
              // Déclencher le chargement de la météo après la sélection
              // _weatherFuture = _getWeather(city.city);
              _weatherFuture = WeatherService.getWeather2(
                coordinates['latitude']!,
                coordinates['longitude']!,
              );
            });
          },
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: suggestions.length,
    );
  }

  Widget _currentlyPage() {
    return FutureBuilder<Map<String, List<dynamic>>?>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (_isLoadingSuggestions) {
          return Center(child: CircularProgressIndicator());
        } else if (showSuggestions && suggestions.isNotEmpty) {
          return _buildSuggestionsListView();
        } else if (_errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              "Error: $_errorMessage",
              style: TextStyle(fontSize: 22, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting &&
            _weatherFuture != null) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          Map<String, List<dynamic>> weather = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Currently",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(_searchCity, style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                if (weather['temperatures'] != null &&
                    weather['temperatures']!.isNotEmpty)
                  Text(
                    "${weather['temperatures']![0]}°C",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 10),
                if (weather['wind_speeds'] != null &&
                    weather['wind_speeds']!.isNotEmpty)
                  Text(
                    "Wind: ${weather['wind_speeds']![0]} km/h",
                    style: TextStyle(fontSize: 18),
                  ),
                SizedBox(height: 5),
                if (weather['weather_codes'] != null &&
                    weather['weather_codes']!.isNotEmpty)
                  Text(
                    "Weather Code: ${weather['weather_codes']![0]}",
                    style: TextStyle(fontSize: 18),
                  ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(
              "Currently \n$_searchCity\nNo weather data available",
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }

  Widget _todayPage() {
    if (_isLoadingSuggestions) {
      return Center(child: CircularProgressIndicator());
    } else if (showSuggestions && suggestions.isNotEmpty) {
      return _buildSuggestionsListView();
    } else if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          "Error: $_errorMessage",
          style: TextStyle(fontSize: 22, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Center(
        child: Text(
          "Today \n$_searchCity",
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _weeklyPage() {
    if (_isLoadingSuggestions) {
      return Center(child: CircularProgressIndicator());
    } else if (showSuggestions && suggestions.isNotEmpty) {
      return _buildSuggestionsListView();
    } else if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          "Error: $_errorMessage",
          style: TextStyle(fontSize: 22, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Center(
        child: Text(
          "Weelky \n$_searchCity",
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  // ################# MAIN BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            SpecialTextField(
              onSearchChanged: (value) async {
                setState(() {
                  _searchCity = value;
                });
                await _getSuggestions(value);
              },
            ),
            geoLocationButton(),
          ],
        ),
      ),
      body: Center(
        child: TabBarView(
          children: [_currentlyPage(), _todayPage(), _weeklyPage()],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TabButton(title: 'Currently', icon: Icon(Icons.sunny), tabIndex: 0),
            TabButton(
              title: 'Today',
              icon: Icon(Icons.calendar_today),
              tabIndex: 1,
            ),
            TabButton(
              title: 'Weekly',
              icon: Icon(Icons.calendar_month),
              tabIndex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final Icon icon;
  final int tabIndex;

  const TabButton({
    super.key,
    required this.title,
    required this.icon,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          IconButton(
            onPressed: () =>
                DefaultTabController.of(context).animateTo(tabIndex),
            icon: icon,
          ),
          Text(title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class SpecialTextField extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  final Function(Map<String, double>)? onLocationSelected;
  final Function(List<LocationSuggestion>, bool)? onSuggestionsChanged;

  const SpecialTextField({
    super.key,
    this.onSearchChanged,
    this.onLocationSelected,
    this.onSuggestionsChanged,
  });

  @override
  State<SpecialTextField> createState() => _SpecialTextFieldState();
}

class _SpecialTextFieldState extends State<SpecialTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: (value) {
              widget.onSearchChanged?.call(value);
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.search),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
