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

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(isDark),
      child: MyApp(isDark: isDark,),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;

  const MyApp({
    super.key,
    required this.isDark,
  });

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
