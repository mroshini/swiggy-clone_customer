// To parse this JSON data, do
//
//     final restaurantDetailsApiModel = restaurantDetailsApiModelFromJson(jsonString);

import 'dart:convert';

import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/service/hive_database/hive_type_ids.dart';
import 'package:hive/hive.dart';

import 'favorites_restaurant_api_model.dart';

part 'restaurant_details_api_model.g.dart';

RestaurantDetailsApiModel restaurantDetailsApiModelFromJson(str) =>
    RestaurantDetailsApiModel.fromJson(json.decode(str));

String restaurantDetailsApiModelToJson(RestaurantDetailsApiModel data) =>
    json.encode(data.toJson());

@HiveType()
class RestaurantDetailsApiModel {
  RestaurantDetailsApiModel({
    this.totalPages,
    this.aCateory,
    this.restaurant,
    this.catFoodItems,
    this.aCart,
  });

  @HiveField(0)
  int totalPages;
  @HiveField(1)
  List<ACateory> aCateory;
  @HiveField(2)
  RestaurantData restaurant;
  @HiveField(3)
  List<CommonCatFoodItem> catFoodItems;
  @HiveField(4)
  CartQuantityPrice aCart;

  factory RestaurantDetailsApiModel.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailsApiModel(
        totalPages: json["totalPages"] == null ? null : json["totalPages"],
        aCateory: json["aCateory"] == null
            ? null
            : List<ACateory>.from(
                json["aCateory"].map((x) => ACateory.fromJson(x))),
        restaurant: json["restaurant"] == null
            ? null
            : RestaurantData.fromJson(json["restaurant"]),
        catFoodItems: json["catFoodItems"] == null
            ? null
            : List<CommonCatFoodItem>.from(
                json["catFoodItems"].map((x) => CommonCatFoodItem.fromJson(x))),
        aCart: json["aCart"] == null
            ? null
            : CartQuantityPrice.fromJson(json["aCart"]),
      );

  Map<String, dynamic> toJson() => {
        "totalPages": totalPages == null ? null : totalPages,
        "aCateory": aCateory == null
            ? null
            : List<dynamic>.from(aCateory.map((x) => x.toJson())),
        "restaurant": restaurant == null ? null : restaurant.toJson(),
        "catFoodItems": catFoodItems == null
            ? null
            : List<dynamic>.from(catFoodItems.map((x) => x.toJson())),
        "aCart": aCart == null ? null : aCart.toJson(),
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

@HiveType()
class ACateory {
  ACateory({
    this.mainCat,
    this.foodCount,
    this.mainCatName,
  });

  @HiveField(0)
  int mainCat;
  @HiveField(1)
  int foodCount;
  @HiveField(2)
  String mainCatName;

  factory ACateory.fromJson(Map<String, dynamic> json) => ACateory(
        mainCat: json["main_cat"] == null ? null : json["main_cat"],
        foodCount: json["foodCount"] == null ? null : json["foodCount"],
        mainCatName:
            json["main_cat_name"] == null ? null : json["main_cat_name"],
      );

  Map<String, dynamic> toJson() => {
        "main_cat": mainCat == null ? null : mainCat,
        "foodCount": foodCount == null ? null : foodCount,
        "main_cat_name": mainCatName == null ? null : mainCatName,
      };
}

//class CatFoodItem {
//  CatFoodItem({
//    this.mainCat,
//    this.foodcount,
//    this.continution,
//    this.aFoodItems,
//    this.mainCatName,
//  });
//
//  int mainCat;
//  int foodcount;
//  int continution;
//  List<ACommonFoodItem> aFoodItems;
//  String mainCatName;
//
//  factory CatFoodItem.fromJson(Map<String, dynamic> json) => CatFoodItem(
//        mainCat: json["main_cat"] == null ? null : json["main_cat"],
//        foodcount: json["foodcount"] == null ? null : json["foodcount"],
//        continution: json["continution"] == null ? null : json["continution"],
//        aFoodItems: json["aFoodItems"] == null
//            ? null
//            : List<ACommonFoodItem>.from(
//                json["aFoodItems"].map((x) => ACommonFoodItem.fromJson(x))),
//        mainCatName:
//            json["main_cat_name"] == null ? null : json["main_cat_name"],
//      );
//
//  Map<String, dynamic> toJson() => {
//        "main_cat": mainCat == null ? null : mainCat,
//        "foodcount": foodcount == null ? null : foodcount,
//        "continution": continution == null ? null : continution,
//        "aFoodItems": aFoodItems == null
//            ? null
//            : List<dynamic>.from(aFoodItems.map((x) => x.toJson())),
//        "main_cat_name": mainCatName == null ? null : mainCatName,
//      };
//}

//class AFoodItem {
//  AFoodItem({
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
//    this.cartDetail,
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
//  String availableFrom;
//  String availableTo;
//  String availableFrom2;
//  String availableTo2;
//  String itemStatus;
//  String image;
//  CartDetail cartDetail;
//  String exactSrc;
//  Availability availability;
//  String showPrice;
//
//  factory AFoodItem.fromJson(Map<String, dynamic> json) => AFoodItem(
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
//        availableFrom:
//            json["available_from"] == null ? null : json["available_from"],
//        availableTo: json["available_to"] == null ? null : json["available_to"],
//        availableFrom2:
//            json["available_from2"] == null ? null : json["available_from2"],
//        availableTo2:
//            json["available_to2"] == null ? null : json["available_to2"],
//        itemStatus: json["item_status"] == null ? null : json["item_status"],
//        image: json["image"] == null ? null : json["image"],
//        cartDetail: json["cart_detail"] == null
//            ? null
//            : CartDetail.fromJson(json["cart_detail"]),
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
//        "available_from": availableFrom == null ? null : availableFrom,
//        "available_to": availableTo == null ? null : availableTo,
//        "available_from2": availableFrom2 == null ? null : availableFrom2,
//        "available_to2": availableTo2 == null ? null : availableTo2,
//        "item_status": itemStatus == null ? null : itemStatus,
//        "image": image == null ? null : image,
//        "cart_detail": cartDetail == null ? null : cartDetail.toJson(),
//        "exact_src": exactSrc == null ? null : exactSrc,
//        "availability": availability == null ? null : availability.toJson(),
//        "show_price": showPrice == null ? null : showPrice,
//      };
//}
//
//class CartDetail {
//  CartDetail({
//    this.quantity,
//    this.itemNote,
//  });
//
//  int quantity;
//  dynamic itemNote;
//
//  factory CartDetail.fromJson(Map<String, dynamic> json) => CartDetail(
//        quantity: json["quantity"] == null ? null : json["quantity"],
//        itemNote: json["item_note"],
//      );
//
//  Map<String, dynamic> toJson() => {
//        "quantity": quantity == null ? null : quantity,
//        "item_note": itemNote,
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

@HiveType()
class RestaurantData {
  RestaurantData({
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
    this.favouriteStatus,
    this.promoStatus,
    this.promocode,
    this.cartExist,
    this.src,
    this.availability,
    this.cuisineText,
    this.distance,
    this.mapSrc,
    this.restaurantTiming,
    this.freeDelivery,
    this.ratingCountText,
  });

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
  dynamic budget;
  @HiveField(7)
  dynamic rating;
  @HiveField(8)
  String resDesc;
  @HiveField(9)
  String mode;
  @HiveField(10)
  String cuisine;
  @HiveField(11)
  bool favouriteStatus;
  @HiveField(12)
  int promoStatus;
  @HiveField(13)
  List<Promocode> promocode;
  @HiveField(14)
  bool cartExist;
  @HiveField(15)
  String src;
  @HiveField(16)
  Availability availability;
  @HiveField(17)
  String cuisineText;
  @HiveField(18)
  dynamic distance;
  @HiveField(19)
  String mapSrc;
  @HiveField(20)
  List<RestaurantTiming> restaurantTiming;
  @HiveField(21)
  String freeDelivery;
  @HiveField(22)
  int ratingCountText;

  factory RestaurantData.fromJson(Map<String, dynamic> json) => RestaurantData(
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
        favouriteStatus:
            json["favourite_status"] == null ? null : json["favourite_status"],
        promoStatus: json["promo_status"] == null ? null : json["promo_status"],
        promocode: json["promocode"] == null
            ? null
            : List<Promocode>.from(
                json["promocode"].map((x) => Promocode.fromJson(x))),
        cartExist: json["cart_exist"] == null ? null : json["cart_exist"],
        src: json["src"] == null ? null : json["src"],
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
        cuisineText: json["cuisine_text"] == null ? null : json["cuisine_text"],
        distance: json["distance"] == null ? null : json["distance"],
        mapSrc: json["map_src"] == null ? null : json["map_src"],
        restaurantTiming: List<RestaurantTiming>.from(
            json["restaurant_timing"].map((x) => RestaurantTiming.fromJson(x))),
        freeDelivery: json['free_delivery'],
        ratingCountText: json['rating_count_text'],
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
        "favourite_status": favouriteStatus == null ? null : favouriteStatus,
        "promo_status": promoStatus == null ? null : promoStatus,
        "promocode": promocode == null
            ? null
            : List<dynamic>.from(promocode.map((x) => x.toJson())),
        "cart_exist": cartExist == null ? null : cartExist,
        "src": src == null ? null : src,
        "availability": availability == null ? null : availability.toJson(),
        "cuisine_text": cuisineText == null ? null : cuisineText,
        "distance": distance == null ? null : distance,
        "map_src": mapSrc == null ? null : mapSrc,
        "free_delivery": freeDelivery == null ? null : freeDelivery,
        "rating_count_text": ratingCountText == null ? null : ratingCountText,
        "restaurant_timing":
            List<dynamic>.from(restaurantTiming.map((x) => x.toJson())),
      };
}

@HiveType()
class RestaurantTiming {
  RestaurantTiming({
    this.dayId,
    this.startTime1,
    this.endTime1,
    this.startTime2,
    this.endTime2,
    this.dayStatus,
    this.fullDay,
    this.day,
  });

  @HiveField(0)
  int dayId;
  @HiveField(1)
  String startTime1;
  @HiveField(2)
  String endTime1;
  @HiveField(3)
  String startTime2;
  @HiveField(4)
  String endTime2;
  @HiveField(5)
  String dayStatus;
  @HiveField(6)
  bool fullDay;
  @HiveField(7)
  String day;

  factory RestaurantTiming.fromJson(Map<String, dynamic> json) =>
      RestaurantTiming(
        dayId: json["day_id"],
        startTime1: json["start_time1"],
        endTime1: json["end_time1"],
        startTime2: json["start_time2"],
        endTime2: json["end_time2"],
        dayStatus: json["day_status"],
        fullDay: json["full_day"],
        day: json["day"],
      );

  Map<String, dynamic> toJson() => {
        "day_id": dayId,
        "start_time1": startTime1,
        "end_time1": endTime1,
        "start_time2": startTime2,
        "end_time2": endTime2,
        "day_status": dayStatus,
        "full_day": fullDay,
        "day": day,
      };
}

@HiveType()
class Promocode {
  Promocode({
    this.id,
    this.promoName,
    this.promoDesc,
    this.promoType,
    this.promoAmount,
    this.minOrderValue,
    this.promoCodeText,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  String promoName;
  @HiveField(2)
  String promoDesc;
  @HiveField(3)
  String promoType;
  @HiveField(4)
  int promoAmount;
  @HiveField(5)
  int minOrderValue;
  @HiveField(6)
  String promoCodeText;

  factory Promocode.fromJson(Map<String, dynamic> json) => Promocode(
        id: json["id"] == null ? null : json["id"],
        promoName: json["promo_name"] == null ? null : json["promo_name"],
        promoDesc: json["promo_desc"] == null ? null : json["promo_desc"],
        promoType: json["promo_type"] == null ? null : json["promo_type"],
        promoAmount: json["promo_amount"] == null ? null : json["promo_amount"],
        minOrderValue:
            json["min_order_value"] == null ? null : json["min_order_value"],
        promoCodeText:
            json["promo_code_text"] == null ? null : json["promo_code_text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "promo_name": promoName == null ? null : promoName,
        "promo_desc": promoDesc == null ? null : promoDesc,
        "promo_type": promoType == null ? null : promoType,
        "promo_amount": promoAmount == null ? null : promoAmount,
        "min_order_value": minOrderValue == null ? null : minOrderValue,
        "promo_code_text": promoCodeText == null ? null : promoCodeText,
      };
}
