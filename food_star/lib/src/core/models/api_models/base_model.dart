import 'package:foodstar/src/core/models/api_models/data_model.dart';

class BaseModel {
  final bool success;
  final String message;
  final DataModel data;
  final List<DataModel> dataList;

  BaseModel({this.success, this.message, this.data, this.dataList});

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null ? DataModel?.fromJson(json['data']) : null,
        dataList: json['data'] != null
            ? List<DataModel>.from(
                json['data'].map((i) => DataModel.fromJson(i)))
            : null,
      );
}

class BaseModelNew {
  final bool success;
  final String message;
  final List<DataModel> dataList;

  BaseModelNew({this.success, this.message, this.dataList});

  factory BaseModelNew.fromJson(Map<String, dynamic> json) => BaseModelNew(
        success: json['success'],
        message: json['message'],
        dataList: json['data'] != null
            ? List<DataModel>.from(
                json['data'].map((i) => DataModel.fromJson(i)))
            : null,
      );
}
