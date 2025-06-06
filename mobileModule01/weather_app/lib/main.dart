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

  void onPressedLocationButton() {
    print("Location button pressed WTF");
  }

  void initState() {
    super.initState();
    _tabController = DefaultTabController.of(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(children: [SpecialTextField(), geoLocationButton()]),
      ),
      body: Center(
        child: TabBarView(
          children: [
            Icon(Icons.currency_bitcoin),
            Icon(Icons.umbrella),
            Icon(Icons.fire_truck),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TabButton(
              title: 'Currently',
              icon: Icon(Icons.sunny),
              onPressed: () => DefaultTabController.of(context).animateTo(0),
            ),
            TabButton(
              title: 'Today',
              icon: Icon(Icons.calendar_today),
              onPressed: () => DefaultTabController.of(context).animateTo(1),
            ),
            TabButton(
              title: 'Weekly',
              icon: Icon(Icons.calendar_month),
              onPressed: () => DefaultTabController.of(context).animateTo(2),
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
  final VoidCallback? onPressed;

  const TabButton({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          IconButton(onPressed: onPressed, icon: icon),
          Text(title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class SpecialTextField extends StatelessWidget {
  const SpecialTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
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
