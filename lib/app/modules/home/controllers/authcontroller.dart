import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:twitch_clone/app/Models/user_model.dart';
import 'package:twitch_clone/app/modules/home/views/DataBase%20Helper/helper.dart';

class AuthController extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);
  User? get getUser => _user.value;

  FirebaseAuth auth = FirebaseAuth.instance;
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  @override
  void onInit() {
    super.onInit();
    _user.bindStream(auth.authStateChanges());
    update();
  }

  Future<String> userSignup(
      {required String email,
      required String name,
      required String password}) async {
    String res = 'some error occur';
    try {
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        UserModel userModel = UserModel(
          userName: name,
          email: email,
          uid: credential.user!.uid,
          joinDate: DateTime.now(),
        );
        await addFirestore(userModel: userModel);
        res = 'success';
      } else {
        Get.snackbar(
          'Error Account Creating',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> userLogin(
      {required String email, required String password}) async {
    String res = 'some error occur';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);

        res = 'success';
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  addFirestore({required UserModel userModel}) async {
    await dataBaseHelper.userCollection
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  logout() async {
    await auth.signOut();
  }
}
