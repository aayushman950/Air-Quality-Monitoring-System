import 'package:aqms/themes/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListTile(
          title: Text("Toggle Theme"),
          trailing: Switch(
            value: Provider.of<ThemeModel>(context).isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeModel>(context, listen: false).toggleTheme();
            },
          ),
        ),
      ),
    );
  }
}
