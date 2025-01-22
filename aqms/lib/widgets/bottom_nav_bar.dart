import 'package:aqms/pages/account_page.dart';
import 'package:aqms/pages/home_page.dart';
import 'package:aqms/pages/history_page.dart';
import 'package:flutter/material.dart';

/*

This is the Bottom Navigation Bar

{This widget is used in main.dart}

*/

class BottomNavBar extends StatefulWidget {

  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentPageIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    // Pass csvData to HomePage
    pages = [
      HomePage(),
      HistoryPage(), // If needed, pass csvData or other parameters
      AccountPage(), // Adjust constructor as required
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home, size: 40),
            icon: Icon(Icons.home_outlined, size: 30),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.analytics, size: 40),
            icon: Icon(Icons.analytics_outlined, size: 30),
            label: 'History',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings, size: 40),
            icon: Icon(Icons.settings_outlined, size: 30),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
