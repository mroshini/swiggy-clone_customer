// To parse this JSON data, do
//
//     final alreadySearchedKeywordsApiModel = alreadySearchedKeywordsApiModelFromJson(jsonString);

import 'dart:convert';

import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';

AlreadySearchedKeywordsApiModel alreadySearchedKeywordsApiModelFromJson(str) =>
    AlreadySearchedKeywordsApiModel.fromJson(json.decode(str));

String alreadySearchedKeywordsApiModelToJson(
        AlreadySearchedKeywordsApiModel data) =>
    json.encode(data.toJson());

class AlreadySearchedKeywordsApiModel {
  AlreadySearchedKeywordsApiModel({
    this.aTopSearch,
    this.aRecentSearch,
    this.aCart,
  });

  List<Search> aTopSearch;
  List<Search> aRecentSearch;
  CartQuantityPrice aCart;

  factory AlreadySearchedKeywordsApiModel.fromJson(Map<String, dynamic> json) =>
      AlreadySearchedKeywordsApiModel(
        aTopSearch: json["aTopSearch"] == null
            ? null
            : List<Search>.from(
                json["aTopSearch"].map((x) => Search.fromJson(x))),
        aRecentSearch: json["aRecentSearch"] == null
            ? null
            : List<Search>.from(
                json["aRecentSearch"].map((x) => Search.fromJson(x))),
        aCart: json["aCart"] == null
            ? null
            : CartQuantityPrice.fromJson(json["aCart"]),
      );

  Map<String, dynamic> toJson() => {
        "aTopSearch": aTopSearch == null
            ? null
            : List<dynamic>.from(aTopSearch.map((x) => x.toJson())),
        "aRecentSearch": aRecentSearch == null
            ? null
            : List<dynamic>.from(aRecentSearch.map((x) => x.toJson())),
        "aCart": aCart == null ? null : aCart.toJson(),
      };
}

class Search {
  Search({
    this.id,
    this.keyword,
    this.restaurantId,
    this.foodId,
    this.type,
  });

  int id;
  String keyword;
  int restaurantId;
  int foodId;
  int type;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        id: json["id"] == null ? null : json["id"],
        keyword: json["keyword"] == null ? null : json["keyword"],
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        foodId: json["food_id"] == null ? null : json["food_id"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "keyword": keyword == null ? null : keyword,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "food_id": foodId == null ? null : foodId,
        "type": type == null ? null : type,
      };
}
