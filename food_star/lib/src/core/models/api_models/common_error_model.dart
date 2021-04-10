// To parse this JSON data, do
//
//     final restaurantDetailsApiModel = restaurantDetailsApiModelFromJson(jsonString);

import 'dart:convert';

CommonErrorModel commonErrorModelFromJson(str) =>
    CommonErrorModel.fromJson(json.decode(str));

String commonErrorModelToJson(CommonErrorModel data) =>
    json.encode(data.toJson());

class CommonErrorModel {
  CommonErrorModel({
    this.invalidRequest,
  });

  InvalidRequest invalidRequest;

  factory CommonErrorModel.fromJson(Map<String, dynamic> json) =>
      CommonErrorModel(
        invalidRequest: json["Invalid Request"] == null
            ? null
            : InvalidRequest.fromJson(json["Invalid Request"]),
      );

  Map<String, dynamic> toJson() => {
        "Invalid Request":
            invalidRequest == null ? null : invalidRequest.toJson(),
      };
}

class InvalidRequest {
  InvalidRequest({
    this.message,
  });

  String message;

  factory InvalidRequest.fromJson(Map<String, dynamic> json) => InvalidRequest(
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
      };
}
