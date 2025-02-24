import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String day;
  final double morningTemp;
  final double afternoonTemp;
  final double nightTemp;
  final bool isToday;

  const WeatherCard({
    Key? key,
    required this.day,
    required this.morningTemp,
    required this.afternoonTemp,
    required this.nightTemp,
    this.isToday = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isToday ? Colors.lightBlue[100] : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text("Morning: ${morningTemp}℃"),
          Text("Afternoon: ${afternoonTemp}℃"),
          Text("Night: ${nightTemp}℃"),
        ],
      ),
    );
  }
}