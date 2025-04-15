import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(AQIApp());
}

class AQIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(bodyLarge: TextStyle(fontFamily: 'Montserrat')),
      ),
      themeMode: ThemeMode.light, // Force light theme
      home: AQIScreen(),
    );
  }
}

class AQIScreen extends StatefulWidget {
  @override
  _AQIScreenState createState() => _AQIScreenState();
}

class _AQIScreenState extends State<AQIScreen> {
  int? aqi;
  String status = "Fetching data...";
  Color statusColor = Colors.grey;

  Future<void> fetchAQI() async {
    final response = await http.get(Uri.parse(
        "https://api.waqi.info/feed/here/?token=1290a0ebf111f90e20be398b7642bc496487617c")); // Replace with your key
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        aqi = data['data']['aqi'];
        _updateStatus();
      });
    } else {
      setState(() {
        status = "Error fetching data";
        statusColor = Colors.red;
      });
    }
  }

  void _updateStatus() {
    if (aqi == null) return;
    if (aqi! <= 50) {
      status = "Good";
      statusColor = Colors.green;
    } else if (aqi! <= 100) {
      status = "Moderate";
      statusColor = Colors.yellow[700]!;
    } else if (aqi! <= 150) {
      status = "Unhealthy for Sensitive Groups";
      statusColor = Colors.orange;
    } else if (aqi! <= 200) {
      status = "Unhealthy";
      statusColor = Colors.red;
    } else {
      status = "Hazardous";
      statusColor = Colors.purple;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAQI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Air Quality Index (AQI)")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_outlined, size: 80, color: statusColor),
              SizedBox(height: 20),
              Text(
                aqi != null ? "AQI: $aqi" : "Loading...",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                status,
                style: TextStyle(fontSize: 20, color: statusColor),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: fetchAQI,
                icon: Icon(Icons.refresh),
                label: Text("Refresh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
