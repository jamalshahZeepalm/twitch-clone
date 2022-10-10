import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:twitch_clone/Responsive/responsive.dart';
import 'package:twitch_clone/app/data/typography.dart';
import 'package:twitch_clone/app/modules/home/views/Auth/login.dart';
import 'package:twitch_clone/app/modules/home/views/Auth/signup.dart';

import '../Widgets/custom_button.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  CustomResponsiveScreen(mychild: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to \n Twitch',
                style: CustomTextStyle.kTextStyle40,
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                  myChild: Text('Login'),
                  onPressed: () {
                    Get.to(
                      () => LoginScreen(),
                    );
                  }),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                  myChild: Text('Sign Up'),
                  onPressed: () {
                    Get.to(
                      () => SignUpScreen(),
                    );
                  })
            ],
          ),
        )),
    );
  }
}
