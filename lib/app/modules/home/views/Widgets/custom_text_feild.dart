import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/colors.dart';

class CustomTextFormFeild extends StatelessWidget {
    CustomTextFormFeild(
      {super.key,
      required this.textInputType,
      required this.validator,
      required this.onChange,
      this.isPass = false,
      this.oTab,
      required this.textEditingController,  });
  final TextEditingController textEditingController;
  final bool isPass;
  final Function(String)? oTab;
    TextInputType textInputType;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: CustomColors.borderColor),
    );
    return TextFormField(
      onFieldSubmitted: oTab,
      keyboardType: textInputType,
      controller: textEditingController,
      obscureText: isPass,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        border: inputBorder,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.buttonColor),
        ),
        enabledBorder: inputBorder,
      ),
      validator: validator,
      onChanged: onChange,
    );
  }
}
