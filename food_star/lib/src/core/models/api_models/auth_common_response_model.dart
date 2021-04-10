import 'dart:convert';

CommonMessageModel commonMessageModelFromJson(str) =>
    CommonMessageModel.fromJson(json.decode(str));

String commonMessageModelToJson(CommonMessageModel data) =>
    json.encode(data.toJson());

class CommonMessageModel {
  String message;
  String accessToken;
  int id;

  CommonMessageModel({this.message, this.accessToken, this.id});

  factory CommonMessageModel.fromJson(Map<String, dynamic> json) {
    return CommonMessageModel(
        message: json['message'],
        accessToken: json['access_token'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    data['id'] = this.id;
    return data;
  }
}
