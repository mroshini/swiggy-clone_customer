import 'dart:convert';

EditProfileApiModel editProfileApiModelFromJson(str) =>
    EditProfileApiModel.fromJson(json.decode(str));

String editProfileApiModelToJson(EditProfileApiModel data) =>
    json.encode(data.toJson());

class EditProfileApiModel {
  int doEmailVerify;
  String message;
  User user;

  EditProfileApiModel({this.doEmailVerify, this.message, this.user});

  EditProfileApiModel.fromJson(Map<String, dynamic> json) {
    doEmailVerify = json['do_email_verify'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['do_email_verify'] = this.doEmailVerify;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String username;
  String email;
  int phoneCode;
  int phoneNumber;
  String avatar;
  int emailVerified;
  String updatedAt;
  String src;

  User(
      {this.username,
      this.email,
      this.phoneCode,
      this.phoneNumber,
      this.avatar,
      this.emailVerified,
      this.updatedAt,
      this.src});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
    emailVerified = json['email_verified'];
    updatedAt = json['updated_at'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone_code'] = this.phoneCode;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    data['email_verified'] = this.emailVerified;
    data['updated_at'] = this.updatedAt;
    data['src'] = this.src;
    return data;
  }
}
