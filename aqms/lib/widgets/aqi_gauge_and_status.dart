import 'package:aqms/widgets/aqi_gauge.dart';
import 'package:aqms/widgets/aqi_status.dart';
import 'package:flutter/material.dart';

/*

This widget takes AQI Rating as Input.
This widget provides AQI Rating to AQIGauge and AQIStatus.
This widget displays AQIStatus below AQIGauge by positioning them in a Stack. 

// Stack was used because AQIGauge was occupying a lot of extra empty space below the semi-circle(gauge). Couldn't find a way to remove that empty space so a Stack was used to position AQIStatus in that empty space. //

{ This widget is used in the HomePage widget (home_page.dart) }

*/

class AQIGaugeAndStatus extends StatelessWidget {
  final int aqiRating;

  const AQIGaugeAndStatus({
    super.key,
    required this.aqiRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Stack(
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
      ),
    );
  }
}
