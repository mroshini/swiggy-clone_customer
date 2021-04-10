import 'dart:convert';

import 'package:foodstar/src/core/service/hive_database/hive_type_ids.dart';
import 'package:hive/hive.dart';

part 'favorites_restaurant_api_model.g.dart';

FavoritesRestaurantApiModel favoritesRestaurantApiModelFromJson(str) =>
    FavoritesRestaurantApiModel.fromJson(json.decode(str));

String favoritesRestaurantApiModelToJson(FavoritesRestaurantApiModel data) =>
    json.encode(data.toJson());

class FavoritesRestaurantApiModel {
  @HiveType()
  List<ARestaurant> aRestaurant;
  int aUser;
  String message;

  FavoritesRestaurantApiModel({this.aRestaurant, this.aUser, this.message});

  FavoritesRestaurantApiModel.fromJson(Map<String, dynamic> json) {
    if (json['aRestaurant'] != null) {
      aRestaurant = new List<ARestaurant>();
      json['aRestaurant'].forEach((v) {
        aRestaurant.add(new ARestaurant.fromJson(v));
      });
    }
    aUser = json['aUser'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aRestaurant != null) {
      data['aRestaurant'] = this.aRestaurant.map((v) => v.toJson()).toList();
    }
    data['aUser'] = this.aUser;
    data['message'] = this.message;
    return data;
  }
}

@HiveType()
class ARestaurant {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String location;
  @HiveField(3)
  String logo;
  @HiveField(4)
  int partnerId;
  @HiveField(5)
  int deliveryTime;
  @HiveField(6)
  int budget;
  @HiveField(7)
  int rating;
  @HiveField(8)
  String resDesc;
  @HiveField(9)
  String mode;
  @HiveField(10)
  String cuisine;
  @HiveField(11)
  int promoStatus;
  @HiveField(12)
  dynamic favouriteStatus;
  @HiveField(13)
  bool cartExist;
  @HiveField(14)
  String src;
  @HiveField(15)
  Availability availability;
  @HiveField(16)
  String cuisineText;
  @HiveField(17)
  String city;

  ARestaurant({
    this.id,
    this.name,
    this.location,
    this.logo,
    this.partnerId,
    this.deliveryTime,
    this.budget,
    this.rating,
    this.resDesc,
    this.mode,
    this.cuisine,
    this.promoStatus,
    this.favouriteStatus,
    this.cartExist,
    this.src,
    this.availability,
    this.cuisineText,
    this.city,
  });

  ARestaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    logo = json['logo'];
    partnerId = json['partner_id'];
    deliveryTime = json['delivery_time'];
    budget = json['budget'];
    rating = json['rating'];
    resDesc = json['res_desc'];
    mode = json['mode'];
    cuisine = json['cuisine'];
    promoStatus = json['promo_status'];
    favouriteStatus = json['favourite_status'];
    cartExist = json['cart_exist'];
    src = json['src'];
    availability = json['availability'] != null
        ? new Availability.fromJson(json['availability'])
        : null;
    cuisineText = json['cuisine_text'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['logo'] = this.logo;
    data['partner_id'] = this.partnerId;
    data['delivery_time'] = this.deliveryTime;
    data['budget'] = this.budget;
    data['rating'] = this.rating;
    data['res_desc'] = this.resDesc;
    data['mode'] = this.mode;
    data['cuisine'] = this.cuisine;
    data['promo_status'] = this.promoStatus;
    data['favourite_status'] = this.favouriteStatus;
    data['cart_exist'] = this.cartExist;
    data['src'] = this.src;
    if (this.availability != null) {
      data['availability'] = this.availability.toJson();
    }
    data['cuisine_text'] = this.cuisineText;
    data['city'] = this.city;
    return data;
  }
}

@HiveType()
class Availability {
  @HiveField(0)
  int status;
  @HiveField(1)
  String text;

  Availability({this.status, this.text});

  Availability.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['text'] = this.text;
    return data;
  }
}
