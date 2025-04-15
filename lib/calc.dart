import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _expression = "";

  void _buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        _output = "0";
        _expression = "";
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          _output = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          _output = "Error";
        }
      } else {
        _expression += value;
        _output = _expression;
      }
    });
  }

  Widget _buildButton(String text, {Color color = Colors.blue}) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        onPressed: () => _buttonPressed(text),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: color,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Simple Calculator",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerRight,
              child: Text(
                _output,
                style: const TextStyle(fontSize: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                for (var row in [
                  ["7", "8", "9", "/"],
                  ["4", "5", "6", "*"],
                  ["1", "2", "3", "-"],
                  ["C", "0", "=", "+"],
                ])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: row.map((e) {
                      bool isOperator = "+-*/=".contains(e);
                      return _buildButton(
                        e,
                        color: isOperator ? Colors.orange : Colors.blueGrey,
                      );
                    }).toList(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
