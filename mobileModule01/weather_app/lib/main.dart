import 'package:flutter/material.dart';

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
  String _searchCity = "";

  void onPressedLocationButton() {
    print("Location button pressed WTF");
    setState(() {
      _searchCity = "Geolocation";
    });
  }

  @override
  void didChangeDepencencies() {
    super.didChangeDependencies();
    _tabController = DefaultTabController.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget geoLocationButton() {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {
        onPressedLocationButton();
      },
      child: Icon(Icons.location_on),
    );
  }

  Widget _currentlyPage() {
    return Expanded(
      child: Center(
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
      ),
    );
  }

  Widget _todayPage() {
    return Expanded(
      child: Center(
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
      ),
    );
  }

  Widget _weeklyPage() {
    return Expanded(
      child: Center(
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
      ),
    );
  }

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
