// To parse this JSON data, do
//
//     final searchRestaurantDishApiModel = searchRestaurantDishApiModelFromJson(jsonString);

import 'dart:convert';

SearchRestaurantDishApiModel searchRestaurantDishApiModelFromJson(str) =>
    SearchRestaurantDishApiModel.fromJson(json.decode(str));

String searchRestaurantDishApiModelToJson(SearchRestaurantDishApiModel data) =>
    json.encode(data.toJson());

class SearchRestaurantDishApiModel {
  SearchRestaurantDishApiModel({
    this.searchList,
    this.type,
    this.message,
  });

  List<SearchList> searchList;
  String type;
  String message;

  factory SearchRestaurantDishApiModel.fromJson(Map<String, dynamic> json) =>
      SearchRestaurantDishApiModel(
        searchList: json["searchList"] == null
            ? null
            : List<SearchList>.from(
                json["searchList"].map((x) => SearchList.fromJson(x))),
        type: json["type"] == null ? null : json["type"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "searchList": searchList == null
            ? null
            : List<dynamic>.from(searchList.map((x) => x.toJson())),
        "type": type == null ? null : type,
        "message": message == null ? null : message,
      };
}

class SearchList {
  SearchList({
    this.id,
    this.name,
    this.image,
    this.src,
    this.availability,
  });

  int id;
  String name;
  String image;
  String src;
  Availability availability;

  factory SearchList.fromJson(Map<String, dynamic> json) => SearchList(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        src: json["src"] == null ? null : json["src"],
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
        "src": src == null ? null : src,
        "availability": availability == null ? null : availability.toJson(),
      };
}

class Availability {
  Availability({
    this.status,
    this.text,
  });

  int status;
  Text text;

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        status: json["status"] == null ? null : json["status"],
        text: json["text"] == null ? null : textValues.map[json["text"]],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "text": text == null ? null : textValues.reverse[text],
      };
}

enum Text { OUT_OF_STOCK }

final textValues = EnumValues({"Out of stock": Text.OUT_OF_STOCK});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
