import 'dart:convert';

UserModel userDataModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String userDataModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? userName;
  String? userProfile;
  String? joiningTime;
  String? leavingTime;

  UserModel(
      {this.id,
      this.userName,
      this.userProfile,
      this.joiningTime,
      this.leavingTime});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        userName: json["userName"],
        userProfile: json["userProfile"],
        joiningTime: json["joiningTime"],
        leavingTime: json["leavingTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "userProfile": userProfile,
        "joiningTime": joiningTime,
        "leavingTime": leavingTime,
      };
}
