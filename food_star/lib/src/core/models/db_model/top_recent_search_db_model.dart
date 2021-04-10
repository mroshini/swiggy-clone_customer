// To parse this JSON data, do
//
//     final alreadySearchedKeywordsApiModel = alreadySearchedKeywordsApiModelFromJson(jsonString);

import 'dart:convert';

TopRecentSearchDbModel topRecentSearchDbModelFromJson(str) =>
    TopRecentSearchDbModel.fromJson(json.decode(str));

String topRecentSearchDbModelToJson(TopRecentSearchDbModel data) =>
    json.encode(data.toJson());

class TopRecentSearchDbModel {
  TopRecentSearchDbModel({
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

  factory TopRecentSearchDbModel.fromJson(Map<String, dynamic> json) =>
      TopRecentSearchDbModel(
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
