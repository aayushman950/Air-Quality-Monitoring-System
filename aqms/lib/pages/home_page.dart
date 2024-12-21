import 'package:aqms/widgets/aqi_gauge_and_status.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.place),
              SizedBox(
                width: 5,
              ),
              Text(
                "Sensor 1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AQIGaugeAndStatus(
            aqiRating: 140,
          ),
        ),
      ),
    );
  }
}
