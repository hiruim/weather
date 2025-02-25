import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/config/app_assests.dart';

class MapScreen extends StatefulWidget {
  final Function(LatLng) onTap;

  MapScreen({required this.onTap});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pinLocation;
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  String? weatherInfo = "Weather data will appear here";

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _pinLocation = _currentLocation;
        });

        // Move the map to the user's current location
        _mapController.move(_currentLocation!, 15.0);
        _fetchWeatherData(position.latitude, position.longitude);
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      print("Location permission denied");
    }
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    final apiUrl =
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          weatherInfo =
              "Temperature: ${data['current_weather']['temperature']}°C";
        });
      } else {
        print("Failed to fetch weather data");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation ?? LatLng(0, 0),
                initialZoom: 15.0,
                onTap: (tapPosition, latLng) {
                  setState(() {
                    _pinLocation = latLng;
                  });
                  widget.onTap(latLng);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                if (_currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation!,
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          AppAssets.location,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                if (_pinLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _pinLocation!,
                        width: 60,
                        height: 60,
                        child: Image.asset(AppAssets.mapPointerIcon),
                      ),
                    ],
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            _mapController.move(_currentLocation!, 15.0);
            _fetchWeatherData(_currentLocation!.latitude, _currentLocation!.longitude);
          }
        },
        child: Image.asset(AppAssets.location, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Text(
          weatherInfo!,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
