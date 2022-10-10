import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitch_clone/app/modules/home/views/Nav%20Bar/bottom_navbar.dart';
import 'package:twitch_clone/app/modules/home/views/OnBoard%20Screen/onboard_screen.dart';

import '../../controllers/authcontroller.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_authController.getUser == null) {
        return OnBoardScreen();
      } else {
        return BottomNavBarScreen();
      }
    });
  }
}
