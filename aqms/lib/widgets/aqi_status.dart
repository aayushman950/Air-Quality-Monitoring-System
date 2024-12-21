import 'package:flutter/material.dart';

/*

This widget calculates and shows the current air quality status like Air Quality is "GOOD", "MODERATE" etc. It takes AQI Rating as Input.

{ This widget is used in the AQIGaugeAndStatus widget (aqi_gauge_and_status.dart) }

*/

class AQIStatus extends StatelessWidget {
  final int aqiRating;

  const AQIStatus({super.key, required this.aqiRating});

  @override
  Widget build(BuildContext context) {
    /*
    
    INITIALIZE VARIABLES
    
    */
    String aqiStatus = "Unknown";
    Color aqiStatusColor = Colors.black;
    Widget aqiStatusTextWidget;

    /* 

    FUNCTIONS
    
    */

    // function to set aqiStatus according to aqiRating
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

    // function that sets aqiStatusColor according to aqiRating
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
    // need to run aqiStatusCalculator before any statements that require aqiStatus (otherwise aqiStatus will always be "Unknown")
    aqiStatusCalculator(aqiRating);
    aqiStatusColorCalculator(aqiRating);

    // styling the aqiStatusTextWidget text according to aqiStatus
    // this was done because "UNHEALTHY FOR SENSITIVE GROUPS" and "VERY UNHEALTHY" were overflowing out of the screen.
    if (aqiStatus == "UNHEALTHY FOR SENSITIVE GROUPS") {
      aqiStatusTextWidget = Column(
        children: [
          Text(
            "UNHEALTHY",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: aqiStatusColor,
            ),
          ),
          Text(
            "for sensitive groups",
            style: TextStyle(
              fontSize: 25,
              color: aqiStatusColor,
            ),
          ),
        ],
      );
    } else if (aqiStatus == "VERY UNHEALTHY") {
      aqiStatusTextWidget = Text(
        aqiStatus,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: aqiStatusColor,
        ),
      );
    } else {
      aqiStatusTextWidget = Text(
        aqiStatus,
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: aqiStatusColor,
        ),
      );
    }

    // the complete widget
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          "Air Quality is",
          style: TextStyle(fontSize: 25),
        ),
        SizedBox(
          height: 100,
          child: aqiStatusTextWidget,
        ),
      ],
    );
  }
}
