import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _cityName = 'London';  // Default city
  String _weatherCondition = 'clear';  // Default weather condition
  double _temperature = 0.0;  // Temperature in Celsius
  String _description = '';  // Weather description
  Color _backgroundColor = Colors.blue;  // Initial background color

  // Map of weather conditions to background colors
  Map<String, Color> weatherBackgroundColors = {
    'clear': Colors.yellow,  // Sunny
    'clouds': Colors.grey,   // Cloudy
    'rain': Colors.blue,     // Rainy
    'snow': Colors.white,    // Snowy
  };

  // Function to fetch weather data from OpenWeatherMap API
  Future<void> fetchWeather() async {
    final apiKey = 'f8a674cf89e35a475daf8cee2c196ee0';  // Replace with your OpenWeatherMap API key
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$apiKey&units=metric');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String weatherCondition = data['weather'][0]['main'].toLowerCase();
        double temperature = data['main']['temp'];
        String description = data['weather'][0]['description'];

        // Update weather condition, temperature, description, and background color
        setState(() {
          _weatherCondition = weatherCondition;
          _temperature = temperature;
          _description = description;
          _backgroundColor = weatherBackgroundColors[weatherCondition] ?? Colors.blue;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();  // Fetch weather when the screen is initialized
  }

  // Function to change background color manually based on button press
  void changeBackgroundColor(String condition) {
    setState(() {
      _weatherCondition = condition;
      _backgroundColor = weatherBackgroundColors[condition] ?? Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Container(
        color: _backgroundColor,  // Set background color dynamically
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display current weather condition (fetched from API)
            Text(
              'Weather: $_weatherCondition'.toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Display temperature
            Text(
              'Temperature: ${_temperature.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            // Display weather description
            Text(
              'Description: $_description',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // Add 4 buttons to change background color manually
            Wrap(
              spacing: 10,
              children: weatherBackgroundColors.keys.map((weather) {
                return ElevatedButton(
                  onPressed: () {
                    changeBackgroundColor(weather);
                  },
                  child: Text(weather.toUpperCase()),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
