import 'package:foodstar/src/core/models/api_models/user_model.dart';

class DataModel {
  final String token;
  final String mobile;
  final UserModel user;

  DataModel({this.token, this.mobile, this.user});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        token: json['token'],
        mobile: json['mobile'] != null ? json['mobile'] : '',
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      );
}
