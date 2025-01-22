import 'package:aqms/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/*

TO-DO: Make onTap of InkWell go to detailed PM Screen

*/


class PMTile extends StatelessWidget {
  final num pmType;
  final double pmValue;

  const PMTile({super.key, required this.pmType, required this.pmValue});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    bool isDarkMode = Provider.of<ThemeModel>(context).isDarkMode;

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 6, // Adds elevation to give a Material design look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: isDarkMode
            ? BorderSide(color: Colors.grey.shade800, width: 1.5) // Add border in dark mode
            : BorderSide.none,
      ),
      color: isDarkMode ? Colors.black : Colors.white,
      shadowColor: isDarkMode ? Colors.white.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
      child: InkWell(
        onTap: () {}, // go to detailed PM screen
        splashColor: Colors.grey.withAlpha(50),
        child: Container(
          width: screenWidth * 0.4,
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "PM$pmType",
                  style: TextStyle(
                    fontSize: 25,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  pmValue.toString(),
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
