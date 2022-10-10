import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/colors.dart';

class CustomButton extends StatelessWidget {
  final Widget myChild;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.myChild,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: myChild,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.buttonColor,
        minimumSize: Size(
          double.infinity.w,
          50.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color: CustomColors.buttonColor,
          ),
        ),
      ),
    );
  }
}
