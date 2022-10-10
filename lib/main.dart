import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitch_clone/app/modules/home/views/Auth/auth_wrapper.dart';
import 'app/data/themes.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/modules/home/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyB3iZ5t8kC5RHd3A9vYWxEF-Yfp6rqoShE",
          authDomain: "twitch-clone-7f4ae.firebaseapp.com",
          projectId: "twitch-clone-7f4ae",
          storageBucket: "twitch-clone-7f4ae.appspot.com",
          messagingSenderId: "700179828736",
          appId: "1:700179828736:web:ded6dd5ef73b8dfe83c8e5"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Twitch Clone",
          home: AuthWrapper(),
          initialBinding: InitialBinding(),
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.lightTheme,
        );
      },
    ),
  );
}
