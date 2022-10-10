import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitch_clone/app/data/colors.dart';

class CustomTextStyle {
  static TextStyle kTextSyle24 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  static TextStyle kTextStyle17 = TextStyle(
    fontSize: ScreenUtil().setSp(17),
    color: CustomColors.backgroundColor,
  );
  static TextStyle kTextStyle40 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: ScreenUtil().setSp(40),
  );
}
