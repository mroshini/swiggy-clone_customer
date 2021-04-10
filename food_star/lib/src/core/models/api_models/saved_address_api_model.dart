import 'dart:convert';

import 'package:foodstar/src/core/service/hive_database/hive_type_ids.dart';
import 'package:hive/hive.dart';

part 'saved_address_api_model.g.dart';

SavedAddressApiModel savedAddressApiModelFromJson(str) =>
    SavedAddressApiModel.fromJson(json.decode(str));

String savedAddressApiModelToJson(SavedAddressApiModel data) =>
    json.encode(data.toJson());

class SavedAddressApiModel {
  List<AAddress> aAddress;
  String message;

  SavedAddressApiModel({this.aAddress});

  SavedAddressApiModel.fromJson(Map<String, dynamic> json) {
    if (json['aAddress'] != null) {
      aAddress = new List<AAddress>();
      json['aAddress'].forEach((v) {
        aAddress.add(new AAddress.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aAddress != null) {
      data['aAddress'] = this.aAddress.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

@HiveType()
class AAddress {
  @HiveField(0)
  dynamic id;
  @HiveField(1)
  dynamic addressType;
  @HiveField(2)
  String building;
  @HiveField(3)
  String landmark;
  @HiveField(4)
  String address;
  @HiveField(5)
  double lat;
  @HiveField(6)
  double lang;
  @HiveField(7)
  String city;
  @HiveField(8)
  String state;
  @HiveField(9)
  dynamic distance;
  @HiveField(10)
  String addressTypeText;

  AAddress(
      {this.id,
      this.addressType,
      this.building,
      this.landmark,
      this.address,
      this.lat,
      this.lang,
      this.city,
      this.state,
      this.distance,
      this.addressTypeText});

  AAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    building = json['building'];
    landmark = json['landmark'];
    address = json['address'];
    lat = json['lat'];
    lang = json['lang'];
    city = json['city'];
    state = json['state'];
    distance = json['distance'];
    addressTypeText = json['address_type_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_type'] = this.addressType;
    data['building'] = this.building;
    data['landmark'] = this.landmark;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['city'] = this.city;
    data['state'] = this.state;
    data['distance'] = this.distance;
    data['address_type_text'] = this.addressTypeText;
    return data;
  }
}
