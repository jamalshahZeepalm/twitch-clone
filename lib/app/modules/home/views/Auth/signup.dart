import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:twitch_clone/Responsive/responsive.dart';
import 'package:twitch_clone/app/data/colors.dart';
import 'package:twitch_clone/app/modules/home/controllers/authcontroller.dart';

import '../../../../data/typography.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_feild.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _nameEditingController.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomResponsiveScreen(
        mychild: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up',
                style: CustomTextStyle.kTextSyle24,
              ),
              SizedBox(
                height: 12.h,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'UserName',
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomTextFormFeild(
                      textInputType: TextInputType.text,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field can't be empty";
                        }
                        return null;
                      },
                      onChange: (change) {},
                      textEditingController: _nameEditingController,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Email',
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomTextFormFeild(
                      textInputType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field can't be empty";
                        }
                        return null;
                      },
                      onChange: (change) {},
                      textEditingController: _emailEditingController,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Password',
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomTextFormFeild(
                      textInputType: TextInputType.text,
                      isPass: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field can't be empty";
                        }
                        return null;
                      },
                      onChange: (change) {},
                      textEditingController: _passwordEditingController,
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                    CustomButton(
                        myChild: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: CustomColors.backgroundColor,
                                ),
                              )
                            : Text('Sign Up'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            registerUser();
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await _authController.userSignup(
      email: _emailEditingController.text,
      name: _nameEditingController.text,
      password: _passwordEditingController.text,
    );
    _emailEditingController.clear();
    _nameEditingController.clear();
    _passwordEditingController.clear();
    if (res == 'success') {
      Get.back();
      Get.snackbar(
        'Account Creation',
        'Successfully Account Created',
      );
      setState(() {
        isLoading = false;
      });
    } else {
      Get.snackbar(
        'Error Logging in',
        res.toString(),
      );
      log(res.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
