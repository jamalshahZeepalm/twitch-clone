import 'package:get/get.dart';
import 'package:twitch_clone/app/modules/home/controllers/golive_controller.dart';
import 'package:twitch_clone/app/modules/home/controllers/user_controller.dart';

import '../controllers/authcontroller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<GoLiveController>(() => GoLiveController(), fenix: true);
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
  }
}
