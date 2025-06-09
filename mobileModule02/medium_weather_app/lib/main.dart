import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather/weather.dart';
import 'services/weather.dart';
import 'services/geocoding.dart';
import 'services/location.dart';

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

  Map<String, double>? coordinates;
  String _city = "";
  String _country = "";
  String _locationStatus = "awaiting...";
  String _searchCity = "";

  String _errorMessage = "";

  Future<void> onPressedLocationButton() async {
    print("Location button pressed Searching current device location...");
    await _getlocation();
    setState(() {
      print("location: $_locationStatus");
      if (coordinates != null) {
        _searchCity = "City: $_city\nCountry: $_country";
      } else {
        _searchCity = _locationStatus;
      }
    });
    if (coordinates != null) {
      await _getWeather();
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

  Future<Weather?> _getWeather() async {
    WeatherFactory? weatherFactory = await WeatherService.initWeatherService(
      "2709c218504646cc4c3251759b90dda6",
    );

    if (weatherFactory == null || coordinates == null) {
      print("Error : WeatherFactory or coordinates null");
      return null;
    }

    double? latitude = coordinates!['latitude'];
    double? longitude = coordinates!['longitude'];

    if (latitude == null || longitude == null) {
      print("Error: Coordinates values null");
      return null;
    }

    Weather? weather = await WeatherService.getWeatherByCoords(
      latitude,
      longitude,
      weatherFactory,
    );
    if (weather != null) {
      print("Weather Data:");
      print("Temperature: ${weather.temperature?.celsius}°C");
      print("Feels Like: ${weather.tempFeelsLike?.celsius}°C");
      print("Humidity: ${weather.humidity}%");
      print("Pressure: ${weather.pressure}hPa");
      print("Wind Speed: ${weather.windSpeed}m/s");
    } else {
      print("Weather data is null");
    }
    return weather;
  }

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

  Widget _currentlyPage() {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Error \n$_searchCity",
              style: TextStyle(fontSize: 22, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Currently \n$_searchCity",
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  Widget _todayPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Today \n$_searchCity",
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _weeklyPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Weekly \n$_searchCity",
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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
              onSearchChanged: (value) {
                setState(() {
                  _searchCity = value;
                });
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

class SpecialTextField extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;

  const SpecialTextField({super.key, this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
