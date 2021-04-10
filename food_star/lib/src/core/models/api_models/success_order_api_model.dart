import 'dart:convert';

SuccessOrderApiModel successOrderApiModelFromJson(str) =>
    SuccessOrderApiModel.fromJson(json.decode(str));

String successOrderApiModelToJson(SuccessOrderApiModel data) =>
    json.encode(data.toJson());

class SuccessOrderApiModel {
  int status;
  String message;
  int orderId;

  SuccessOrderApiModel({this.status, this.message, this.orderId});

  SuccessOrderApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['orderId'] = this.orderId;
    return data;
  }
}
