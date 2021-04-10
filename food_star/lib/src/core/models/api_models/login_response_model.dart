import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String message;
  String accessToken;
  int id;

  LoginResponseModel({this.message, this.accessToken});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accessToken = json['access_token'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    data['id'] = this.id;
    return data;
  }
}
