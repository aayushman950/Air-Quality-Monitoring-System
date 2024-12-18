import 'package:aqms/themes/dark_theme.dart';
import 'package:aqms/themes/light_theme.dart';
import 'package:aqms/models/theme_model.dart';
import 'package:aqms/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.isDarkMode ? darkTheme : lightTheme,
          home: BottomNavBar(),
        );
      },
    );
  }
}
