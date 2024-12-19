import 'package:flutter/material.dart';

class AQIStatus extends StatelessWidget {
  const AQIStatus({super.key, required this.airStatus});

  final String airStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Air Quality is",
          style: TextStyle(fontSize: 25),
        ),
        Text(
          airStatus,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
