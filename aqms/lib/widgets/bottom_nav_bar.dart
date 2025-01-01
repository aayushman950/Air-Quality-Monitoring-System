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

  final List pages = [HomePage(), HistoryPage(), AccountPage()];

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
            selectedIcon: Icon(Icons.notifications, size: 40),
            icon: Icon(Icons.notifications_none_outlined, size: 30),
            label: 'Notifications',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle, size: 40),
            icon: Icon(Icons.account_circle_outlined, size: 30),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
