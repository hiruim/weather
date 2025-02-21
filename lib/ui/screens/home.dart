import 'package:flutter/material.dart';
import 'package:weather/config/text_styles.dart';
import 'package:weather/ui/widgets/map.dart';
import 'package:weather/ui/widgets/weather_card.dart';
import 'package:weather/ui/widgets/weather_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherData weather = WeatherData(
    city: "Paris",
    temperature: "-7.7",
    windSpeed: "3.8",
    midnightTemp: "-6.4",
    minTemp: "-8.6",
    morningTemp: "-8.2",
    afternoonTemp: "-1.3",
    eveningTemp: "-2.7",
    nightTemp: "-5.5",
  );

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
              height: screenHeight * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: MapScreen(), // Make sure MapScreen widget is defined
            ),
            SizedBox(height: 15),
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
                    // Implement weather check functionality here
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
            SizedBox(height: 15),
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
            // Corrected the redundant widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WeatherCard(day: "Yesterday", morningTemp: -5.2, afternoonTemp: 1.0, nightTemp: -4.4),
                WeatherCard(day: "Today", morningTemp: -8.2, afternoonTemp: 0.0, nightTemp: -4.4, isToday: true),
                WeatherCard(day: "Tomorrow", morningTemp: -6.0, afternoonTemp: 2.0, nightTemp: -3.5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
