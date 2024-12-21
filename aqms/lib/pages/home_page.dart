import 'package:aqms/widgets/aqi_gauge_and_status.dart';
import 'package:aqms/widgets/both_pm_tile.dart';
import 'package:aqms/widgets/pm_tile.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AQIGaugeAndStatus(
                aqiRating: 140,
              ),
              BothPMTile(pmTwoPointFiveValue: 100, pmTenValue: 120)
            ],
          ),
        ),
      ),
    );
  }
}
