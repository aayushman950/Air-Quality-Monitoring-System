import 'package:aqms/widgets/aqi_gauge.dart';
import 'package:aqms/widgets/aqi_status.dart';
import 'package:flutter/material.dart';

class AQIGaugeAndStatus extends StatelessWidget {
  final int aqiRating;

  const AQIGaugeAndStatus({
    super.key,
    required this.aqiRating,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        AQIGauge(
          aqiRating: aqiRating,
        ),
        Positioned(
          bottom: 0,
          child: AQIStatus(aqiRating: aqiRating),
        ),
      ],
    );
  }
}
