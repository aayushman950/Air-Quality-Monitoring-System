import 'package:aqms/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PMTile extends StatelessWidget {
  final num pmType;
  final int pmValue;

  const PMTile({super.key, required this.pmType, required this.pmValue});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    bool isDarkMode = Provider.of<ThemeModel>(context).isDarkMode;

    return Container(
      width: screenWidth * 0.4,
      height: 150,
      decoration: BoxDecoration(
          color: isDarkMode? Colors.black: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: isDarkMode? Colors.white.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(2, 2),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "PM$pmType",
                style: const TextStyle(
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
      ),
    );
  }
}
