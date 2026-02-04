import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import 'home_page.dart';
import '../providers/stats_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StatsPage(),
    const Center(child: Text('Баары')), // Placeholder for "All" page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textGrey,
          selectedLabelStyle: GoogleFonts.rubik(fontWeight: FontWeight.w500),
          unselectedLabelStyle: GoogleFonts.rubik(),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outlined),
              activeIcon: Icon(Icons.check_box),
              label: 'Башкы',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Жыйынтык',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.calendar_month_outlined),
            //   activeIcon: Icon(Icons.calendar_month),
            //   label: 'Баары',
            // ),
          ],
        ),
      ),
    );
  }
}
