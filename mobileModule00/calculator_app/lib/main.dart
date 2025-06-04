// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
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
  String _outputText = '0';
  String _inputText = '0';
  String lastChar = '';
  ExpressionParser mathParser = GrammarParser();

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _clearOne();
      } else if (buttonText == 'AC') {
        _clearAll();
      } else if (['+', '-', '×', '/'].contains(buttonText)) {
        _handleOperator(buttonText);
      } else if (buttonText == '=') {
        _calculateResult();
        //   } else if (buttonText == '+/-') {
        //     _toggleSign();
      } else {
        _handleNumber(buttonText);
      }
      print("last Char: $lastChar");
      if (!(['C', 'AC'].contains(buttonText))) lastChar = buttonText;
    });
  }

  void _clearAll() {
    print("clear all");
    _outputText = '0';
    _inputText = '0';
  }

  void _clearOne() {
    if (_inputText.length > 1) {
      _inputText = _inputText.substring(0, _inputText.length - 1);
    } else {
      _inputText = '0';
    }
    print("clear one");
  }

  void _handleNumber(String number) {
    print("Number: $number");
    setState(() {
      if (_inputText.length == 1 &&
          (_inputText[0] == '0' || _inputText[0] == '00')) {
        _inputText = number;
      } else {
        _inputText = _inputText + number;
      }
    });
  }

  void _handleOperator(String operator) {
    print("operator: $operator");
    if (_inputText.length == 1 &&
        (_inputText[0] == '0') &&
        ['-'].contains(operator)) {
      _inputText = operator;
    } else if (['+', '×', '/'].contains(lastChar)) {
      if (operator != lastChar) {
        _inputText = _inputText.substring(0, _inputText.length - 1);
        _inputText = _inputText + operator;
      }
    } else if (!(['-'].contains(lastChar) &&
        ['+', '×', '/'].contains(operator)))
      _inputText = _inputText + operator;
  }

  void _calculateResult() {
    print("calculate: [$_inputText]");
    if ((['+', '-', '.', '×', '/'].contains(lastChar))) {
      _outputText = 'invalid expression';
    }
    if (!(['+', '-', '.', '×', '/'].contains(lastChar))) {
      Expression expression = mathParser.parse(_inputText);
      String result = expression
          .evaluate(EvaluationType.REAL, ContextModel())
          .toString();
      setState(() {
        _outputText = result;
      });
    }
  }

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
      body: Center(
        child: MainContainer(
          displayText: _outputText,
          initialText: _inputText,
          onButtonPressed: _onButtonPressed,
        ),
      ),
    );
  }
}

class MainContainer extends StatefulWidget {
  final String displayText;
  final String initialText;
  final Function(String) onButtonPressed;

  const MainContainer({
    super.key,
    required this.displayText,
    required this.onButtonPressed,
    required this.initialText,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  static const digitColor = Color.fromARGB(255, 47, 47, 62);
  static const operatorColor = Color.fromARGB(255, 255, 255, 255);
  static const clearColor = Color.fromARGB(255, 207, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 12),
          child: Text(widget.initialText, style: const TextStyle(fontSize: 32)),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 12),
          child: Text(widget.displayText, style: const TextStyle(fontSize: 32)),
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
                    onPressed: () => widget.onButtonPressed('7'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '8',
                    onPressed: () => widget.onButtonPressed('8'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '9',
                    onPressed: () => widget.onButtonPressed('9'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: 'C',
                    onPressed: () => widget.onButtonPressed('C'),
                    buttonColor: clearColor,
                  ),
                  CalculatorButton(
                    buttonTitle: 'AC',
                    onPressed: () => widget.onButtonPressed('AC'),
                    buttonColor: clearColor,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalculatorButton(
                    buttonTitle: '4',
                    onPressed: () => widget.onButtonPressed('4'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '5',
                    onPressed: () => widget.onButtonPressed('5'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '6',
                    onPressed: () => widget.onButtonPressed('6'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '+',
                    onPressed: () => widget.onButtonPressed('+'),
                    buttonColor: operatorColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '-',
                    onPressed: () => widget.onButtonPressed('-'),
                    buttonColor: operatorColor,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalculatorButton(
                    buttonTitle: '1',
                    onPressed: () => widget.onButtonPressed('1'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '2',
                    onPressed: () => widget.onButtonPressed('2'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '3',
                    onPressed: () => widget.onButtonPressed('3'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '×',
                    onPressed: () => widget.onButtonPressed('×'),
                    buttonColor: operatorColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '/',
                    onPressed: () => widget.onButtonPressed('/'),
                    buttonColor: operatorColor,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalculatorButton(
                    buttonTitle: '0',
                    onPressed: () => widget.onButtonPressed('0'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '.',
                    onPressed: () => widget.onButtonPressed('.'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '00',
                    onPressed: () => widget.onButtonPressed('00'),
                    buttonColor: digitColor,
                  ),
                  CalculatorButton(
                    buttonTitle: '=',
                    onPressed: () => widget.onButtonPressed('='),
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
