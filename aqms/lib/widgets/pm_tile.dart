import 'package:flutter/material.dart';

class PMTile extends StatelessWidget {
  final num pmType;
  final int pmValue;

  const PMTile({super.key, required this.pmType, required this.pmValue});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.4,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "PM$pmType",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              Text(
                pmValue.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
