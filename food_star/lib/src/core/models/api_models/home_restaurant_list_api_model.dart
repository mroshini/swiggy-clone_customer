// To parse this JSON data, do
//
//     final homeRestaurantListApiModel = homeRestaurantListApiModelFromJson(jsonString);

import 'dart:convert';

import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/restaurant_details_api_model.dart';
import 'package:foodstar/src/core/service/hive_database/hive_type_ids.dart';
import 'package:hive/hive.dart';

import 'favorites_restaurant_api_model.dart';

part 'home_restaurant_list_api_model.g.dart';

HomeRestaurantListApiModel homeRestaurantListApiModelFromJson(str) =>
    HomeRestaurantListApiModel.fromJson(json.decode(str));

String homeRestaurantListApiModelToJson(HomeRestaurantListApiModel data) =>
    json.encode(data.toJson());

@HiveType()
class HomeRestaurantListApiModel {
  @HiveField(0)
  List<Restaurant> restaurant;
  @HiveField(1)
  int restaurantCount;
  @HiveField(2)
  int totalPages;
  @HiveField(3)
  List<ASlider> aSlider;
  @HiveField(4)
  int demo;
  @HiveField(5)
  List<RestaurantCity> restaurantCities;
  @HiveField(6)
  List<AFilter> aFilter;
  @HiveField(7)
  CartQuantityPrice aCart;
  @HiveField(8)
  List<ACuisines> aCuisines;

  HomeRestaurantListApiModel(
      {this.restaurant,
      this.restaurantCount,
      this.totalPages,
      this.aSlider,
      this.demo,
      this.aFilter,
      this.restaurantCities,
      this.aCart,
      this.aCuisines});

  factory HomeRestaurantListApiModel.fromJson(Map<String, dynamic> json) =>
      HomeRestaurantListApiModel(
        restaurant: json["restaurant"] == null
            ? null
            : List<Restaurant>.from(
                json["restaurant"].map((x) => Restaurant.fromJson(x))),
        restaurantCount:
            json["restaurantCount"] == null ? null : json["restaurantCount"],
        totalPages: json["totalPages"] == null ? null : json["totalPages"],
        aSlider: json["aSlider"] == null
            ? null
            : List<ASlider>.from(
                json["aSlider"].map((x) => ASlider.fromJson(x))),
        demo: json["demo"] == null ? null : json["demo"],
        restaurantCities: json["restaurantCities"] == null
            ? null
            : List<RestaurantCity>.from(json["restaurantCities"]
                .map((x) => RestaurantCity.fromJson(x))),
        aFilter: json["aFilter"] == null
            ? null
            : List<AFilter>.from(
                json["aFilter"].map((x) => AFilter.fromJson(x))),
        aCart: json["aCart"] == null
            ? null
            : CartQuantityPrice.fromJson(json["aCart"]),
        aCuisines: json["aCuisines"] == null
            ? null
            : List<ACuisines>.from(
                json["aCuisines"].map((x) => ACuisines.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurant": restaurant == null
            ? null
            : List<dynamic>.from(restaurant.map((x) => x.toJson())),
        "restaurantCount": restaurantCount == null ? null : restaurantCount,
        "totalPages": totalPages == null ? null : totalPages,
        "aSlider": aSlider == null
            ? null
            : List<dynamic>.from(aSlider.map((x) => x.toJson())),
        "demo": demo == null ? null : demo,
        "restaurantCities": restaurantCities == null
            ? null
            : List<dynamic>.from(restaurantCities.map((x) => x.toJson())),
        "aFilter": aFilter == null
            ? null
            : List<dynamic>.from(aFilter.map((x) => x.toJson())),
        "aCart": aCart == null ? null : aCart.toJson(),
        "aCuisines": aCuisines == null
            ? null
            : List<dynamic>.from(aCuisines.map((x) => x.toJson())),
      };
}

@HiveType()
class AFilter {
  AFilter({
    this.filterName,
    this.filterValues,
  });

  @HiveField(0)
  String filterName;
  @HiveField(1)
  List<FilterValue> filterValues;

  factory AFilter.fromJson(Map<String, dynamic> json) => AFilter(
        filterName: json["filter_name"] == null ? null : json["filter_name"],
        filterValues: json["filter_values"] == null
            ? null
            : List<FilterValue>.from(
                json["filter_values"].map((x) => FilterValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filter_name": filterName == null ? null : filterName,
        "filter_values": filterValues == null
            ? null
            : List<dynamic>.from(filterValues.map((x) => x.toJson())),
      };
}

@HiveType()
class FilterValue {
  FilterValue({
    this.id,
    this.name,
    this.src,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(3)
  String src;

  factory FilterValue.fromJson(Map<String, dynamic> json) => FilterValue(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        src: json["src"] == null ? null : json["src"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "src": src == null ? null : src,
      };
}

@HiveType()
class ASlider {
  @HiveField(0)
  int id;
  @HiveField(1)
  String image;
  @HiveField(2)
  String src;
  @HiveField(3)
  int type;

  ASlider({
    this.id,
    this.image,
    this.src,
    this.type,
  });

  factory ASlider.fromJson(Map<String, dynamic> json) => ASlider(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        src: json["src"] == null ? null : json["src"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "src": src == null ? null : src,
        "type": type == null ? null : type,
      };
}

@HiveType()
class Restaurant {
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
  dynamic deliveryTime;
  @HiveField(6)
  int budget;
  @HiveField(7)
  dynamic rating;
  @HiveField(8)
  String resDesc;
  @HiveField(9)
  String mode;
  @HiveField(10)
  String cuisine;
  @HiveField(11)
  dynamic distance;
  @HiveField(12)
  int promoStatus;
  @HiveField(13)
  bool favouriteStatus;
  @HiveField(14)
  String src;
  @HiveField(15)
  Availability availability;
  @HiveField(16)
  String cuisineText;
  @HiveField(17)
  RestaurantDetailsApiModel restaurantDetails;
  @HiveField(18)
  dynamic minimumOrder;
  @HiveField(19)
  String freeDelivery;

  Restaurant({
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
    this.distance,
    this.cuisine,
    this.promoStatus,
    this.favouriteStatus,
    this.src,
    this.availability,
    this.cuisineText,
    this.restaurantDetails,
    this.minimumOrder,
    this.freeDelivery,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        location: json["location"] == null ? null : json["location"],
        logo: json["logo"] == null ? null : json["logo"],
        partnerId: json["partner_id"] == null ? null : json["partner_id"],
        deliveryTime:
            json["delivery_time"] == null ? null : json["delivery_time"],
        budget: json["budget"] == null ? null : json["budget"],
        rating: json["rating"] == null ? null : json["rating"],
        resDesc: json["res_desc"] == null ? null : json["res_desc"],
        mode: json["mode"] == null ? null : json["mode"],
        cuisine: json["cuisine"] == null ? null : json["cuisine"],
        distance: json["distance"] == null ? null : json["distance"],
        promoStatus: json["promo_status"] == null ? null : json["promo_status"],
        favouriteStatus:
            json["favourite_status"] == null ? null : json["favourite_status"],
        src: json["src"] == null ? null : json["src"],
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
        cuisineText: json["cuisine_text"] == null ? null : json["cuisine_text"],
        minimumOrder: json['minimum_order'],
        freeDelivery: json['free_delivery'],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "location": location == null ? null : location,
        "logo": logo == null ? null : logo,
        "partner_id": partnerId == null ? null : partnerId,
        "delivery_time": deliveryTime == null ? null : deliveryTime,
        "budget": budget == null ? null : budget,
        "rating": rating == null ? null : rating,
        "res_desc": resDesc == null ? null : resDesc,
        "mode": mode == null ? null : mode,
        "cuisine": cuisine == null ? null : cuisine,
        "distance": distance == null ? null : distance,
        "promo_status": promoStatus == null ? null : promoStatus,
        "favourite_status": favouriteStatus == null ? null : favouriteStatus,
        "src": src == null ? null : src,
        "availability": availability == null ? null : availability.toJson(),
        "cuisine_text": cuisineText == null ? null : cuisineText,
        "minimum_order": minimumOrder == null ? null : minimumOrder,
        "free_delivery": freeDelivery == null ? null : freeDelivery,
      };
}

@HiveType()
class ACuisines {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String image;
  @HiveField(3)
  String src;

  ACuisines({this.id, this.name, this.image, this.src});

  ACuisines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['src'] = this.src;
    return data;
  }
}

//class Availability {
//  Availability({
//    this.status,
//    this.text,
//  });
//
//  int status;
//  String text;
//
//  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
//        status: json["status"] == null ? null : json["status"],
//        text: json["text"] == null ? null : json["text"],
//      );
//
//  Map<String, dynamic> toJson() => {
//        "status": status == null ? null : status,
//        "text": text == null ? null : text,
//      };
//}

@HiveType()
class RestaurantCity {
  RestaurantCity({
    this.city,
  });

  @HiveField(0)
  String city;

  factory RestaurantCity.fromJson(Map<String, dynamic> json) => RestaurantCity(
        city: json["city"] == null ? null : json["city"],
      );

  Map<String, dynamic> toJson() => {
        "city": city == null ? null : city,
      };
}
