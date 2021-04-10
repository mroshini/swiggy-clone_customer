import 'dart:convert';

CountryCodeDBModel countryCodeDBModelFromJson(str) =>
    CountryCodeDBModel.fromJson(json.decode(str));

String countryCodeDBModelToJson(CountryCodeDBModel data) =>
    json.encode(data.toJson());

class CountryCodeDBModel {
  List<Countries> aCountries;

  CountryCodeDBModel({this.aCountries});

  CountryCodeDBModel.fromJson(Map<String, dynamic> json) {
    if (json['aCountries'] != null) {
      aCountries = new List<Countries>();
      json['aCountries'].forEach((v) {
        aCountries.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aCountries != null) {
      data['aCountries'] = this.aCountries.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  String name;
  int phoneCode;
  int id;

  Countries({this.name, this.phoneCode, this.id});

  Countries.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneCode = json['phone_code'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone_code'] = this.phoneCode;
    data['id'] = this.id;
    return data;
  }
}

//class CountryCodeDBModel {
//  String name;
//  int phonecode;
//  int id;
//
//  CountryCodeDBModel({this.name, this.phonecode, this.id});
//
//  CountryCodeDBModel.fromJson(Map<String, dynamic> json) {
//    name = json['name'];
//    phonecode = json['phonecode'];
//    id = json['id'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['name'] = this.name;
//    data['phonecode'] = this.phonecode;
//    data['id'] = this.id;
//    return data;
//  }
//}
