import 'dart:convert';

AppEssentialsCoreDataModel appEssentialsCoreDataModelFromJson(str) =>
    AppEssentialsCoreDataModel.fromJson(json.decode(str));

String appEssentialsCoreDataModelToJson(AppEssentialsCoreDataModel data) =>
    json.encode(data.toJson());

class AppEssentialsCoreDataModel {
  AClient aClient;
  List<ACountries> aCountries;
  String currencySymbol;
  String androidLink;
  String iosLink;

  AppEssentialsCoreDataModel(
      {this.aClient,
      this.aCountries,
      this.currencySymbol,
      this.androidLink,
      this.iosLink});

  AppEssentialsCoreDataModel.fromJson(Map<String, dynamic> json) {
    aClient =
        json['aClient'] != null ? new AClient.fromJson(json['aClient']) : null;

    if (json['aCountries'] != null) {
      aCountries = new List<ACountries>();
      json['aCountries'].forEach((v) {
        aCountries.add(new ACountries.fromJson(v));
      });
    }
    currencySymbol = json['currency_symbol'];
    androidLink = json['android_link'];
    iosLink = json['ios_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aClient != null) {
      data['aClient'] = this.aClient.toJson();
    }
    if (this.aCountries != null) {
      data['aCountries'] = this.aCountries.map((v) => v.toJson()).toList();
    }
    data['currency_symbol'] = this.currencySymbol;
    data['android_link'] = this.androidLink;
    data['ios_link'] = this.iosLink;

    return data;
  }
}

class AClient {
  String id;
  String secret;

  AClient({this.id, this.secret});

  AClient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secret = json['secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['secret'] = this.secret;
    return data;
  }
}

class ACountries {
  String name;
  int phoneCode;
  int id;

  ACountries({this.name, this.phoneCode, this.id});

  ACountries.fromJson(Map<String, dynamic> json) {
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
