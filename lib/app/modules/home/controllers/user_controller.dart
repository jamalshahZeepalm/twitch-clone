import 'dart:developer';

import 'package:get/get.dart';
import 'package:twitch_clone/app/Models/user_model.dart';
import 'package:twitch_clone/app/modules/home/views/DataBase%20Helper/helper.dart';

import 'authcontroller.dart';

class UserController extends GetxController {
  final Rx<UserModel?> _userModel = UserModel(
    userName: '',
    email: '',
    uid: '',
    joinDate: '',
  ).obs;
  UserModel get user => _userModel.value!;
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  @override
  void onReady() async {
    _userModel.value = await userStream();
    super.onReady();
    log(_userModel.value!.email);
  }

  Future<UserModel> userStream() async {
    return await dataBaseHelper.userCollection
        .doc(Get.find<AuthController>().getUser!.uid)
        .get()
        .then(
          (value) => UserModel.fromMap(
            value.data() as Map<String, dynamic>,
          ),
        );
  }
}
