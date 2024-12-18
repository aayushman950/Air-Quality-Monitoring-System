import 'package:aqms/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AQIGauge extends StatelessWidget {
  const AQIGauge({super.key});

  @override
  Widget build(BuildContext context) {
    int aqiRating = 167;

    return Container(
      height: 400,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            radiusFactor: 0.95,
            axisLineStyle: AxisLineStyle(
              thickness: 30,
            ),
            startAngle: 180,
            endAngle: 0,
            interval: 50,
            showTicks: false,
            minimum: 0,
            maximum: 320,
            ranges: [
              GaugeRange(
                  startValue: 0,
                  endValue: 50,
                  color: Colors.green,
                  startWidth: 30,
                  endWidth: 30),
              GaugeRange(
                  startValue: 50,
                  endValue: 100,
                  color: Colors.yellow,
                  startWidth: 30,
                  endWidth: 30),
              GaugeRange(
                  startValue: 100,
                  endValue: 150,
                  color: Colors.orange,
                  startWidth: 30,
                  endWidth: 30),
              GaugeRange(
                  startValue: 150,
                  endValue: 200,
                  color: Colors.red,
                  startWidth: 30,
                  endWidth: 30),
              GaugeRange(
                  startValue: 200,
                  endValue: 300,
                  color: Colors.purple.shade400,
                  startWidth: 30,
                  endWidth: 30),
              GaugeRange(
                  startValue: 300,
                  endValue: 350,
                  color: Colors.red.shade900,
                  startWidth: 30,
                  endWidth: 30),
            ],
            pointers: [
              MarkerPointer(
                value: aqiRating.toDouble(),
                color: Provider.of<ThemeModel>(context).isDarkMode
                    ? Colors.white
                    : Colors.black,
                markerHeight: 30,
                markerWidth: 20,
                markerType: MarkerType.triangle,
                markerOffset: 40,
              )
            ],
            annotations: [
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "AQI",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: aqiRating.toString(), // The number part
                            style: TextStyle(
                              fontSize: 50, // Larger font size for the number
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' µg/m³', // The unit part
                            style: TextStyle(
                              fontSize: 20, // Smaller font size for the unit
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                angle: 270,
                positionFactor: 0.2,
              )
            ],
          )
        ],
      ),
    );
  }
}
