import 'package:flutter/material.dart';

class PMTile extends StatelessWidget {
  const PMTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: Colors.amber,

        borderRadius: BorderRadius.circular(25)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Column(
          children: [
            Text(
              "PM2.5",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(
              "100",
              style: TextStyle(
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
