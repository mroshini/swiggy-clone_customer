// To parse this JSON data, do
//
//     final searchApiModel = searchApiModelFromJson(jsonString);

import 'dart:convert';

import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/service/hive_database/hive_type_ids.dart';
import 'package:hive/hive.dart';

import 'favorites_restaurant_api_model.dart';

part 'search_api_model.g.dart';

SearchApiModel searchApiModelFromJson(str) =>
    SearchApiModel.fromJson(json.decode(str));

String searchApiModelToJson(SearchApiModel data) => json.encode(data.toJson());

class SearchApiModel {
  SearchApiModel({
    this.aFoodItems,
    this.aRestaurant,
    this.aCart,
    this.message,
  });

  //List<AFoodItem> aFoodItems;

  List<CommonCatFoodItem> aFoodItems;
  List<ARestaurant> aRestaurant;
  CartQuantityPrice aCart;
  String message;

  factory SearchApiModel.fromJson(Map<String, dynamic> json) => SearchApiModel(
        aFoodItems: json["aFoodItems"] == null
            ? null
            : List<CommonCatFoodItem>.from(
                json["aFoodItems"].map((x) => CommonCatFoodItem.fromJson(x))),
        aRestaurant: json["aRestaurant"] == null
            ? null
            : List<ARestaurant>.from(
                json["aRestaurant"].map((x) => ARestaurant.fromJson(x))),
        aCart: json["aCart"] == null
            ? null
            : CartQuantityPrice.fromJson(json["aCart"]),
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "aFoodItems": aFoodItems == null
            ? null
            : List<dynamic>.from(aFoodItems.map((x) => x.toJson())),
        "aRestaurant": aRestaurant == null
            ? null
            : List<dynamic>.from(aRestaurant.map((x) => x.toJson())),
        "aCart": aCart == null ? null : aCart.toJson(),
        "message": message == null ? null : message,
      };
}

//class ACart {
//  ACart({
//    this.totalQuantity,
//    this.totalPrice,
//  });
//
//  dynamic totalQuantity;
//  dynamic totalPrice;
//
//  factory ACart.fromJson(Map<String, dynamic> json) => ACart(
//        totalQuantity: json["total_quantity"],
//        totalPrice: json["total_price"],
//      );
//
//  Map<String, dynamic> toJson() => {
//        "total_quantity": totalQuantity,
//        "total_price": totalPrice,
//      };
//}

//class AFoodItem {
//  AFoodItem({
//    this.id,
//    this.restaurantId,
//    this.restaurantDetail,
//    this.foodItemView,
//  });
//
//  int id;
//  int restaurantId;
//  RestaurantDetail restaurantDetail;
//  List<ACommonFoodItem> foodItemView;
//
//  factory AFoodItem.fromJson(Map<String, dynamic> json) => AFoodItem(
//        id: json["id"] == null ? null : json["id"],
//        restaurantId:
//            json["restaurant_id"] == null ? null : json["restaurant_id"],
//        restaurantDetail: json["restaurant_detail"] == null
//            ? null
//            : RestaurantDetail.fromJson(json["restaurant_detail"]),
//        foodItemView: json["food_item_view"] == null
//            ? null
//            : List<ACommonFoodItem>.from(
//                json["food_item_view"].map((x) => ACommonFoodItem.fromJson(x))),
//      );
//
//  Map<String, dynamic> toJson() => {
//        "id": id == null ? null : id,
//        "restaurant_id": restaurantId == null ? null : restaurantId,
//        "restaurant_detail":
//            restaurantDetail == null ? null : restaurantDetail.toJson(),
//        "food_item_view": foodItemView == null
//            ? null
//            : List<dynamic>.from(foodItemView.map((x) => x.toJson())),
//      };
//}

//class FoodItemView {
//  FoodItemView({
//    this.id,
//    this.restaurantId,
//    this.foodItem,
//    this.description,
//    this.price,
//    this.sellingPrice,
//    this.originalPrice,
//    this.status,
//    this.availableFrom,
//    this.availableTo,
//    this.availableFrom2,
//    this.availableTo2,
//    this.itemStatus,
//    this.image,
//    this.cartQuantity,
//    this.exactSrc,
//    this.availability,
//    this.showPrice,
//  });
//
//  int id;
//  int restaurantId;
//  String foodItem;
//  String description;
//  int price;
//  int sellingPrice;
//  int originalPrice;
//  String status;
//  Available availableFrom;
//  Available availableTo;
//  Available availableFrom2;
//  AvailableTo2 availableTo2;
//  String itemStatus;
//  String image;
//  int cartQuantity;
//  String exactSrc;
//  Availability availability;
//  String showPrice;
//
//  factory FoodItemView.fromJson(Map<String, dynamic> json) => FoodItemView(
//        id: json["id"] == null ? null : json["id"],
//        restaurantId:
//            json["restaurant_id"] == null ? null : json["restaurant_id"],
//        foodItem: json["food_item"] == null ? null : json["food_item"],
//        description: json["description"] == null ? null : json["description"],
//        price: json["price"] == null ? null : json["price"],
//        sellingPrice:
//            json["selling_price"] == null ? null : json["selling_price"],
//        originalPrice:
//            json["original_price"] == null ? null : json["original_price"],
//        status: json["status"] == null ? null : json["status"],
//        availableFrom: json["available_from"] == null
//            ? null
//            : availableValues.map[json["available_from"]],
//        availableTo: json["available_to"] == null
//            ? null
//            : availableValues.map[json["available_to"]],
//        availableFrom2: json["available_from2"] == null
//            ? null
//            : availableValues.map[json["available_from2"]],
//        availableTo2: json["available_to2"] == null
//            ? null
//            : availableTo2Values.map[json["available_to2"]],
//        itemStatus: json["item_status"] == null ? null : json["item_status"],
//        image: json["image"] == null ? null : json["image"],
//        cartQuantity:
//            json["cart_quantity"] == null ? null : json["cart_quantity"],
//        exactSrc: json["exact_src"] == null ? null : json["exact_src"],
//        availability: json["availability"] == null
//            ? null
//            : Availability.fromJson(json["availability"]),
//        showPrice: json["show_price"] == null ? null : json["show_price"],
//      );
//
//  Map<String, dynamic> toJson() => {
//        "id": id == null ? null : id,
//        "restaurant_id": restaurantId == null ? null : restaurantId,
//        "food_item": foodItem == null ? null : foodItem,
//        "description": description == null ? null : description,
//        "price": price == null ? null : price,
//        "selling_price": sellingPrice == null ? null : sellingPrice,
//        "original_price": originalPrice == null ? null : originalPrice,
//        "status": status == null ? null : status,
//        "available_from": availableFrom == null
//            ? null
//            : availableValues.reverse[availableFrom],
//        "available_to":
//            availableTo == null ? null : availableValues.reverse[availableTo],
//        "available_from2": availableFrom2 == null
//            ? null
//            : availableValues.reverse[availableFrom2],
//        "available_to2": availableTo2 == null
//            ? null
//            : availableTo2Values.reverse[availableTo2],
//        "item_status": itemStatus == null ? null : itemStatus,
//        "image": image == null ? null : image,
//        "cart_quantity": cartQuantity == null ? null : cartQuantity,
//        "exact_src": exactSrc == null ? null : exactSrc,
//        "availability": availability == null ? null : availability.toJson(),
//        "show_price": showPrice == null ? null : showPrice,
//      };
//}
//

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
//
//enum Available { THE_1200_AM, THE_1200_PM }
//
//final availableValues = EnumValues(
//    {"12:00am": Available.THE_1200_AM, "12:00pm": Available.THE_1200_PM});
//
//enum AvailableTo2 { THE_1200_AM, THE_500_PM }
//
//final availableTo2Values = EnumValues(
//    {"12:00am": AvailableTo2.THE_1200_AM, "5:00pm": AvailableTo2.THE_500_PM});

@HiveType()
class RestaurantDetail {
  RestaurantDetail({
    this.id,
    this.name,
    this.cuisine,
    this.rating,
    this.deliveryTime,
    this.mode,
    this.cartExist,
    this.availability,
    this.cuisineText,
    this.src,
    this.city,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String cuisine;
  @HiveField(3)
  int rating;
  @HiveField(4)
  int deliveryTime;
  @HiveField(5)
  String mode;
  @HiveField(6)
  bool cartExist;
  @HiveField(7)
  Availability availability;
  @HiveField(8)
  String cuisineText;
  @HiveField(9)
  String src;
  @HiveField(10)
  int city;

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        cuisine: json["cuisine"] == null ? null : json["cuisine"],
        rating: json["rating"] == null ? null : json["rating"],
        deliveryTime:
            json["delivery_time"] == null ? null : json["delivery_time"],
        mode: json["mode"] == null ? null : json["mode"],
        cartExist: json["cart_exist"] == null ? null : json["cart_exist"],
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
        cuisineText: json["cuisine_text"] == null ? null : json["cuisine_text"],
        src: json["src"] == null ? null : json["src"],
        city: json["city"] == null ? null : json["city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "cuisine": cuisine == null ? null : cuisine,
        "rating": rating == null ? null : rating,
        "delivery_time": deliveryTime == null ? null : deliveryTime,
        "mode": mode == null ? null : mode,
        "cart_exist": cartExist == null ? null : cartExist,
        "availability": availability == null ? null : availability.toJson(),
        "cuisine_text": cuisineText == null ? null : cuisineText,
        "src": src == null ? null : src,
        "city": city == null ? null : city,
      };
}

class ARestaurant {
  ARestaurant({
    this.distance,
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

  dynamic distance;
  int id;
  String name;
  String location;
  String logo;
  int partnerId;
  dynamic deliveryTime;
  dynamic budget;
  dynamic rating;
  String resDesc;
  String mode;
  String cuisine;
  int promoStatus;
  bool favouriteStatus;
  bool cartExist;
  String src;
  Availability availability;
  String cuisineText;
  int city;

  factory ARestaurant.fromJson(Map<String, dynamic> json) => ARestaurant(
        distance: json["distance"] == null ? null : json["distance"],
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
        promoStatus: json["promo_status"] == null ? null : json["promo_status"],
        favouriteStatus:
            json["favourite_status"] == null ? null : json["favourite_status"],
        cartExist: json["cart_exist"] == null ? null : json["cart_exist"],
        src: json["src"] == null ? null : json["src"],
        city: json["city"] == null ? null : json["city"],
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
        cuisineText: json["cuisine_text"] == null ? null : json["cuisine_text"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance == null ? null : distance,
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
        "promo_status": promoStatus == null ? null : promoStatus,
        "favourite_status": favouriteStatus == null ? null : favouriteStatus,
        "cart_exist": cartExist == null ? null : cartExist,
        "src": src == null ? null : src,
        "city": city == null ? null : city,
        "availability": availability == null ? null : availability.toJson(),
        "cuisine_text": cuisineText == null ? null : cuisineText,
      };
}

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
