import 'package:aqms/widgets/aqi_gauge.dart';
import 'package:aqms/widgets/aqi_status.dart';
import 'package:flutter/material.dart';

class AQIGaugeAndStatus extends StatelessWidget {
  final int aqiRating;

  const AQIGaugeAndStatus({
    super.key,
    required this.aqiRating,
  });

  String aqiStatusCalculator(int aqiRating) {
    if (aqiRating >= 0 && aqiRating <= 50) {
      return 'GOOD';
    } else if (aqiRating >= 51 && aqiRating <= 100) {
      return "MODERATE";
    } else if (aqiRating >= 101 && aqiRating <= 150) {
      return "UNHEALTHY FOR SENSITIVE GROUPS";
    } else if (aqiRating >= 151 && aqiRating <=200) {
      return "UNHEALTHY";
    }else if (aqiRating >= 201 && aqiRating <=300) {
      return "VERY UNHEALTHY";
    }else if (aqiRating >= 301) {
      return "HAZARDOUS";
    } else {
      return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        AQIGauge(
          aqiRating: aqiRating,
        ),
        Positioned(
          bottom: 40,
          child: AQIStatus(
            aqiStatus: aqiStatusCalculator(aqiRating),
          ),
        ),
      ],
    );
  }
}
