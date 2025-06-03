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
      title: 'ex02',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 49, 18, 83),
        ),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String buttonTitle;
  final Color? buttonColor;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.buttonColor,
  });

  void onButtonPressed() {
    print('Button $buttonTitle pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
        ),
        child: Text(
          buttonTitle,
          style: TextStyle(
            color: buttonColor ?? const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 108, 138),

        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
      body: Center(child: MainContainer()),
    );
  }
}

class MainContainer extends StatelessWidget {
  const MainContainer({super.key});

  static const digitColor = Color.fromARGB(255, 47, 47, 62);
  static const operatorColor = Color.fromARGB(255, 255, 255, 255);
  static const clearColor = Color.fromARGB(255, 255, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const TextField(
          // Input field
          readOnly: true,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 32),
          decoration: InputDecoration(hintText: '0'),
        ),
        const TextField(
          // Output field
          readOnly: true,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 32),
          decoration: InputDecoration(hintText: '0'),
        ),
        Expanded(child: Container()),
        Container(
          padding: const EdgeInsets.all(4.0),
          color: const Color.fromARGB(255, 107, 108, 138),
          child: Column(
            // Buttons
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalculatorButton(
                    buttonTitle: '7',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '8',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '9',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: 'C',
                    onPressed: () {},
                    buttonColor: clearColor,
                  ),
                  CalculatorButton(
                    buttonTitle: 'AC',
                    onPressed: () {},
                    buttonColor: clearColor,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalculatorButton(
                    buttonTitle: '4',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '5',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '6',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '+',
                    onPressed: () {},
                    buttonColor: operatorColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '-',
                    onPressed: () {},
                    buttonColor: operatorColor,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalculatorButton(
                    buttonTitle: '1',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '2',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '3',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: 'x',
                    onPressed: () {},
                    buttonColor: operatorColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '/',
                    onPressed: () {},
                    buttonColor: operatorColor,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalculatorButton(
                    buttonTitle: '0',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '.',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '00',
                    onPressed: () {},
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '=',
                    onPressed: () {},
                    buttonColor: operatorColor,
                  ),
                  CalculatorButton(buttonTitle: ' ', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
