import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/config/text_styles.dart';
import 'package:weather/ui/widgets/weather_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(48.8566, 2.3522); // Default location (Paris)
  Marker? _marker;

  WeatherData weather = WeatherData(
    city: "Paris",
    temperature: "-7.7",
    windSpeed: "3.8 (Feels colder)",
    midnightTemp: "-6.4",
    minTemp: "-8.6",
    morningTemp: "-8.2",
    afternoonTemp: "-1.3",
    eveningTemp: "-2.7",
    nightTemp: "-5.5",
  );

  @override
  void initState() {
    super.initState();
    _setMarker(_initialPosition);
    _getCurrentLocation();
  }

  void _setMarker(LatLng position) {
    setState(() {
      _marker = Marker(
        markerId: MarkerId('location'),
        position: position,
        infoWindow: InfoWindow(title: 'Selected Location'),
        draggable: true,
        onDragEnd: (newPosition) {
          setState(() {
            _initialPosition = newPosition;
          });
        },
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _initialPosition = currentLatLng;
      _setMarker(currentLatLng);
    });

    _mapController.animateCamera(CameraUpdate.newLatLng(currentLatLng));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 22.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialPosition, zoom: 14),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: _marker != null ? {_marker!} : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onTap: (LatLng latLng) {
                    _setMarker(latLng);
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // /////////////////////////////
                  },
                  child: const Text(
                    "How's Weather?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: screenWidth * 0.9,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(187, 222, 251, 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    
                    child: Text(
                      weather.city,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text("🌡 Temperature: ${weather.temperature}°C",
                      style: dataTextStyle()),
                  Text("💨 Wind Speed: ${weather.windSpeed} km/h",
                      style: dataTextStyle()),
                  Text("🌙 Midnight: ${weather.midnightTemp}°C",
                      style: dataTextStyle()),
                  Text("📉 Minimum Temperature: ${weather.minTemp}°C",
                      style: dataTextStyle()),
                  Text("☀️ Morning: ${weather.morningTemp}°C",
                      style: dataTextStyle()),
                  Text("🌇 Afternoon: ${weather.afternoonTemp}°C",
                      style: dataTextStyle()),
                  Text("🌆 Evening: ${weather.eveningTemp}°C",
                      style: dataTextStyle()),
                  Text("🌙 Night: ${weather.nightTemp}°C",
                      style: dataTextStyle()),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
