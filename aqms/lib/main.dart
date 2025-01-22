import 'package:aqms/themes/dark_theme.dart';
import 'package:aqms/themes/light_theme.dart';
import 'package:aqms/models/theme_model.dart';
import 'package:aqms/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool('isDark') ?? false;

  // Hardcoded CSV data (for simplicity, replace with actual data source if needed)
  const String csvData = """
result,table,_start,_stop,_time,_value,_field,_measurement,location,sensor
_result,0,2024-01-01T08:00:00Z,2026-01-01T20:00:01Z,2025-01-10T07:57:02Z,25.1,pm10,air_quality,Dhulikhel,raspberry
_result,0,2024-01-01T08:00:00Z,2026-01-01T20:00:01Z,2025-01-10T08:03:21Z,24,pm10,air_quality,Dhulikhel,raspberry
_result,1,2024-01-01T08:00:00Z,2026-01-01T20:00:01Z,2025-01-10T08:09:42Z,17.6,pm25,air_quality,Dhulikhel,raspberry
_result,1,2024-01-01T08:00:00Z,2026-01-01T20:00:01Z,2025-01-10T08:03:21Z,17.3,pm25,air_quality,Dhulikhel,raspberry
""";

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(isDark),
      child: MyApp(
        isDark: isDark,
         // Pass csvData here
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;

  const MyApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.isDarkMode ? darkTheme : lightTheme,
          home: BottomNavBar(), // Pass csvData to BottomNavBar
        );
      },
    );
  }
}
