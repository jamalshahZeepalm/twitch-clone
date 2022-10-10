import 'package:flutter/material.dart';
import 'package:twitch_clone/app/data/colors.dart';

import '../../../../data/const.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: CustomColors.buttonColor,
        unselectedItemColor: CustomColors.kPrimaryColor,
        backgroundColor: CustomColors.backgroundColor,
        unselectedFontSize: 12,
        onTap: onPageChange,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_rounded,
            ),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.copy,
            ),
            label: 'Browse',
          ),
        ],
      ),
      body: pages[_page],
    );
  }

  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }
}
