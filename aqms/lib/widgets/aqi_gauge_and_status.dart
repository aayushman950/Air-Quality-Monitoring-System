import 'package:aqms/widgets/aqi_gauge.dart';
import 'package:aqms/widgets/aqi_status.dart';
import 'package:flutter/material.dart';

class AQIGaugeAndStatus extends StatelessWidget {
  const AQIGaugeAndStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        AQIGauge(aqiRating: 20,),
        Positioned(
          bottom: 40,
          child: AQIStatus(airStatus: 'Good',),
        ),
      ],
    );
  }
}
