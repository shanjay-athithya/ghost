import 'package:flutter/material.dart';

void main() {
  runApp(CalorieBurnCalculatorApp());
}

class CalorieBurnCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 18),
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 18),
          headlineSmall: TextStyle(fontFamily: 'Poppins', fontSize: 22),
        ),
      ),
      home: CalorieBurnCalculatorScreen(),
    );
  }
}

class CalorieBurnCalculatorScreen extends StatefulWidget {
  @override
  _CalorieBurnCalculatorScreenState createState() =>
      _CalorieBurnCalculatorScreenState();
}

class _CalorieBurnCalculatorScreenState
    extends State<CalorieBurnCalculatorScreen> {
  TextEditingController weightController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  String selectedActivity = 'Running';
  double caloriesBurned = 0.0;

  final Map<String, double> activityMETs = {
    'Running': 8.0,
    'Walking': 3.5,
    'Cycling': 6.0,
    'Swimming': 7.0,
  };

  void calculateCalories() {
    double weight = double.tryParse(weightController.text) ?? 60.0;
    double duration = double.tryParse(durationController.text) ?? 30.0;
    double metValue = activityMETs[selectedActivity] ?? 3.5;
    setState(() {
      caloriesBurned = (metValue * 3.5 * weight / 200) * duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calorie Burn Calculator")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter your weight (kg):", style: TextStyle(fontSize: 18)),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter weight',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text("Select Activity Type:", style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: selectedActivity,
              items: activityMETs.keys.map((activity) {
                return DropdownMenuItem(value: activity, child: Text(activity));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value!;
                });
              },
            ),
            SizedBox(height: 10),
            Text("Enter duration (minutes):", style: TextStyle(fontSize: 18)),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter duration in minutes',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateCalories,
              child: Text("Calculate"),
            ),
            SizedBox(height: 20),
            Text("Calories Burned: ${caloriesBurned.toStringAsFixed(2)} kcal",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}
