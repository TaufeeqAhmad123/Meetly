import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetly/screen/home.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),


  ];  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        items:  [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/home.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/chat.svg'),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/setting.svg'),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/user.svg'),
            label: 'Profile',
          ),
        ],
         // Set the current index based on your logic
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}