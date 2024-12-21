import 'package:aqms/widgets/aqi_gauge_and_status.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
