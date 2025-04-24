import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
//geolocator: ^10.1.0
//dependency_overrides:
//   geolocator_android: 4.1.7
void main() {
  runApp(const MaterialApp(
    home: NearbyHotelsPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class NearbyHotelsPage extends StatefulWidget {
  const NearbyHotelsPage({super.key});

  @override
  State<NearbyHotelsPage> createState() => _NearbyHotelsPageState();
}

class _NearbyHotelsPageState extends State<NearbyHotelsPage> {
  String? locationMessage;

  Future<void> _getCurrentLocationAndShowHotels() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location services
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationMessage = 'Location services are disabled.';
      });
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage = 'Location permissions are permanently denied.';
      });
      return;
    }

    // Get location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double lon = position.longitude;

    setState(() {
      locationMessage = 'Your location: ($lat, $lon)';
    });

    // Google Maps search URL
    final url =
        'https://www.google.com/maps/search/hotels/@$lat,$lon,15z';

    // Launch URL
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        locationMessage = 'Could not launch Google Maps.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Hotels")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getCurrentLocationAndShowHotels,
              child: const Text("Find Nearby Hotels"),
            ),
            const SizedBox(height: 20),
            Text(locationMessage ?? ''),
          ],
        ),
      ),
    );
  }
}
