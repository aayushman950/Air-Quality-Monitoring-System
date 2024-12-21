import 'package:flutter/material.dart';

class PMTile extends StatelessWidget {
  final int pmType, pmValue;

  const PMTile({super.key, required this.pmType, required this.pmValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Column(
          children: [
            Text(
              "PM${pmType}",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Text(
              pmValue.toString(),
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
