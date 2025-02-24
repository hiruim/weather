import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather/bloc/weather/weather_bloc.dart';
import 'package:weather/bloc/weather/weather_event.dart';
import 'package:weather/bloc/weather/weather_state.dart';
import 'package:weather/config/text_styles.dart';
import 'package:weather/ui/widgets/map.dart';
import 'package:weather/ui/widgets/weather_card.dart';
import 'package:weather/ui/widgets/weather_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? currentLocation;
  WeatherData weather = WeatherData.init();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider<WeatherMapBloc>(
      create: (context) => WeatherMapBloc(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 22.0,
        ),
        body: BlocConsumer<WeatherMapBloc, WeatherMapState>(
          listener: (context, state) {
            if (state is WeatherLoaded) {
              setState(() {
                weather = state.weatherData;
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.6,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: MapScreen(
                      onTap: (LatLng location) {
                        setState(() {
                          currentLocation = location;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
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
                          if (currentLocation != null) {
                            context.read<WeatherMapBloc>().add(
                                  FetchWeatherEvent(currentLocation!),
                                );
                          }
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
                  const SizedBox(height: 15),
                  Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(187, 222, 251, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            weather.city.isNotEmpty
                                ? weather.city
                                : "Loading city...",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("🌡 Temperature: ${weather.temperature}",
                            style: dataTextStyle()),
                        Text("💨 Wind Speed: ${weather.windSpeed}",
                            style: dataTextStyle()),
                        Text("🌙 Midnight: ${weather.midnightTemp}",
                            style: dataTextStyle()),
                        Text("📉 Minimum Temperature: ${weather.minTemp}",
                            style: dataTextStyle()),
                        Text("☀️ Morning: ${weather.morningTemp}",
                            style: dataTextStyle()),
                        Text("🌇 Afternoon: ${weather.afternoonTemp}",
                            style: dataTextStyle()),
                        Text("🌆 Evening: ${weather.eveningTemp}",
                            style: dataTextStyle()),
                        Text("🌙 Night: ${weather.nightTemp}",
                            style: dataTextStyle()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 2, bottom: 2), // Padding on two corners
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 150,
                            child: WeatherCard(
                              day: "Yesterday",
                              morningTemp: weather.yesterdayMorningTemp,
                              afternoonTemp: weather.yesterdayAfternoonTemp,
                              nightTemp: weather.yesterdayNightTemp,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 150,
                            child: WeatherCard(
                              day: "Tomorrow",
                              morningTemp: weather.tomorrowMorningTemp,
                              afternoonTemp: weather.tomorrowAfternoonTemp,
                              nightTemp: weather.tomorrowNightTemp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
