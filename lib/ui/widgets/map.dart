import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/config/app_assests.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pinLocation;
  LatLng? _currentLocation; 
  final MapController _mapController = MapController();

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

        _mapController.move(_currentLocation!, 15.0);
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      print("Location permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(0, 0),
          initialZoom: 2.0,
          onTap: (tapPosition, latLng) {
            setState(() {
              _pinLocation = latLng;
              print(
                  "first Pin Location: ${latLng.latitude}, ${latLng.longitude}");
            });
            print("New Pin Location: ${latLng.latitude}, ${latLng.longitude}");
          },
        ),
        children: [
          openStreetMapTileLayer,
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
          if (_pinLocation != null) {
            _mapController.move(_pinLocation!, 15.0);
          }
        },
        child: Image.asset(
          AppAssets.location,
          color: Colors.blue,
        ),
      ),
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      );
}
