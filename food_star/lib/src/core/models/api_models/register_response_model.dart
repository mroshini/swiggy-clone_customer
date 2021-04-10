import 'dart:convert';

RegisterResponseModel registerResponseModelFromJson(str) =>
    RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel data) =>
    json.encode(data.toJson());

class RegisterResponseModel {
  String message;
  int confirmation;
  String accessToken;
  int id;

  RegisterResponseModel(
      {this.message, this.confirmation, this.accessToken, this.id});

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    confirmation = json['confirmation'];
    accessToken = json['access_token'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['confirmation'] = this.confirmation;
    data['access_token'] = this.accessToken;
    data['id'] = this.id;
    return data;
  }
}
