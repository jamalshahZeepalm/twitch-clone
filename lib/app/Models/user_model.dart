import 'dart:convert';

class UserModel {
  String userName;
  String email;
  String uid;
  final joinDate;
  UserModel(
      {required this.userName,
      required this.email,
      required this.uid,
      required this.joinDate});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userName': userName});
    result.addAll({'email': email});
    result.addAll({'uid': uid});
    result.addAll({'joinDate': joinDate});
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      joinDate: map['joinDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
