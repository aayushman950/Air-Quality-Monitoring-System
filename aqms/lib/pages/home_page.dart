import 'package:aqms/widgets/aqi_gauge_and_status.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: AQIGaugeAndStatus(aqiRating:260,)),
    );
  }
}
