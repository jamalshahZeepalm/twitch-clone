import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:twitch_clone/Responsive/responsive.dart';
import 'package:twitch_clone/app/modules/home/views/Widgets/custom_text_feild.dart';

import '../../../../data/colors.dart';
import '../../../../data/typography.dart';
import '../../controllers/authcontroller.dart';
import '../Widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();
  bool isLoading = false;
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
                'Login',
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
                      textInputType: TextInputType.emailAddress,
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
                            : Text('Login'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            logUser();
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

  @override
  void dispose() {
    super.dispose();

    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  logUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await _authController.userLogin(
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    );
    _emailEditingController.clear();

    _passwordEditingController.clear();
    if (res == 'success') {
      Get.back();
      Get.snackbar(
        'Account Signing',
        'successfully Signin..',
      );
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error Logging in',
        res.toString(),
      );
    }
  }
}
