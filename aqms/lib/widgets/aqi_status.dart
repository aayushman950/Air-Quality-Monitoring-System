import 'package:flutter/material.dart';

class AQIStatus extends StatelessWidget {
  const AQIStatus({super.key, required this.aqiRating});

  final int aqiRating;

  @override
  Widget build(BuildContext context) {
    String aqiStatus = "Unknown";
    Color aqiStatusColor = Colors.black;

    void aqiStatusCalculator(int aqiRating) {
      if (aqiRating >= 0 && aqiRating <= 50) {
        aqiStatus = "GOOD";
      } else if (aqiRating >= 51 && aqiRating <= 100) {
        aqiStatus = "MODERATE";
      } else if (aqiRating >= 101 && aqiRating <= 150) {
        aqiStatus = "UNHEALTHY FOR SENSITIVE GROUPS";
      } else if (aqiRating >= 151 && aqiRating <= 200) {
        aqiStatus = "UNHEALTHY";
      } else if (aqiRating >= 201 && aqiRating <= 300) {
        aqiStatus = "VERY UNHEALTHY";
      } else if (aqiRating >= 301) {
        aqiStatus = "HAZARDOUS";
      } else {
        aqiStatus = "Unknown";
      }
    }

    void aqiStatusColorCalculator(int aqiRating) {
      if (aqiRating >= 0 && aqiRating <= 50) {
        aqiStatusColor = Colors.green;
      } else if (aqiRating >= 51 && aqiRating <= 100) {
        aqiStatusColor = Colors.yellow;
      } else if (aqiRating >= 101 && aqiRating <= 150) {
        aqiStatusColor = Colors.orange;
      } else if (aqiRating >= 151 && aqiRating <= 200) {
        aqiStatusColor = Colors.red;
      } else if (aqiRating >= 201 && aqiRating <= 300) {
        aqiStatusColor = Colors.purple;
      } else if (aqiRating >= 301) {
        aqiStatusColor = Colors.red.shade900;
      } else {
        aqiStatusColor = Colors.black;
      }
    }

    // running the functions
    aqiStatusCalculator(aqiRating);
    aqiStatusColorCalculator(aqiRating);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Air Quality is",
          style: TextStyle(fontSize: 25),
        ),
        Text(
          aqiStatus,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: aqiStatusColor,
          ),
        ),
      ],
    );
  }
}
