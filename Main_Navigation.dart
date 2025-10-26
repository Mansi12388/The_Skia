// main_navigation.dart - Bottom Navigation Bar

import 'package:flutter/material.dart';
import 'package:parivartan/CommonMan_Module/Health_Dental_Camp/Homepage.dart';
import 'package:parivartan/CommonMan_Module/Health_Dental_Camp/My_Registration.dart';
import 'package:parivartan/CommonMan_Module/Health_Dental_Camp/Register_Page.dart';
//import 'app_colors.dart';
//import 'home_page.dart';
//import 'register_page.dart';
//import 'my_registrations_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const RegisterPage(),
    const MyRegistrationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.navyBlue,
          unselectedItemColor: AppColors.textLight,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 20,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 26),
              activeIcon: Icon(Icons.home_rounded, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_rounded, size: 26),
              activeIcon: Icon(Icons.add_circle_rounded, size: 28),
              label: 'Register',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 26),
              activeIcon: Icon(Icons.person_rounded, size: 28),
              label: 'My Registrations',
            ),
          ],
        ),
      ),
    );
  }
}
