// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import 'package:twitch_clone/app/modules/home/bindings/home_binding.dart';
import 'package:twitch_clone/app/modules/home/views/Dashboard/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
