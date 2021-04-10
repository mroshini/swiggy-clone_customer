import 'package:foodstar/src/core/models/api_models/search_api_model.dart';
import 'package:foodstar/src/core/service/hive_database/hive_type_ids.dart';
import 'package:hive/hive.dart';

import 'favorites_restaurant_api_model.dart';

part 'food_items_api_model.g.dart';

@HiveType()
class CommonCatFoodItem {
  CommonCatFoodItem({
    this.mainCat,
    this.foodcount,
    this.continution,
    this.aFoodItems,
    this.mainCatName,
    this.id,
    this.restaurantId,
    this.restaurantDetail,
  });

  @HiveField(0)
  int mainCat;
  @HiveField(1)
  int foodcount;
  @HiveField(2)
  int continution;
  @HiveField(3)
  int id;
  @HiveField(4)
  int restaurantId;
  @HiveField(5)
  RestaurantDetail restaurantDetail;
  @HiveField(6)
  List<ACommonFoodItem> aFoodItems;
  @HiveField(7)
  String mainCatName;

  factory CommonCatFoodItem.fromJson(Map<String, dynamic> json) =>
      CommonCatFoodItem(
        mainCat: json["main_cat"] == null ? null : json["main_cat"],
        foodcount: json["foodcount"] == null ? null : json["foodcount"],
        continution: json["continution"] == null ? null : json["continution"],
        mainCatName:
            json["main_cat_name"] == null ? null : json["main_cat_name"],
        id: json["id"] == null ? null : json["id"],
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        restaurantDetail: json["restaurant_detail"] == null
            ? null
            : RestaurantDetail.fromJson(json["restaurant_detail"]),
//        aFoodItems: json["aFoodItems"] == null
//            ? null
//            : List<ACommonFoodItem>.from(
//                json["aFoodItems"].map((x) => ACommonFoodItem.fromJson(x))),
        aFoodItems: json["food_item_view"] == null
            ? null
            : List<ACommonFoodItem>.from(
                json["food_item_view"].map((x) => ACommonFoodItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main_cat": mainCat == null ? null : mainCat,
        "foodcount": foodcount == null ? null : foodcount,
        "continution": continution == null ? null : continution,
        "main_cat_name": mainCatName == null ? null : mainCatName,
        "id": id == null ? null : id,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "restaurant_detail":
            restaurantDetail == null ? null : restaurantDetail.toJson(),
//        "aFoodItems": aFoodItems == null
//            ? null
//            : List<dynamic>.from(aFoodItems.map((x) => x.toJson())),
        "food_item_view": aFoodItems == null
            ? null
            : List<dynamic>.from(aFoodItems.map((x) => x.toJson())),
      };
}

@HiveType()
class ACommonFoodItem {
  ACommonFoodItem({
    this.id,
    this.restaurantId,
    this.foodItem,
    this.description,
    this.price,
    this.sellingPrice,
    this.originalPrice,
    this.status,
    this.availableFrom,
    this.availableTo,
    this.availableFrom2,
    this.availableTo2,
    this.itemStatus,
    this.image,
    this.cartDetail,
    this.exactSrc,
    this.availability,
    this.showPrice,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  int restaurantId;
  @HiveField(2)
  String foodItem;
  @HiveField(3)
  String description;
  @HiveField(4)
  int price;
  @HiveField(5)
  int sellingPrice;
  @HiveField(6)
  int originalPrice;
  @HiveField(7)
  String status;
  @HiveField(8)
  String availableFrom;
  @HiveField(9)
  String availableTo;
  @HiveField(10)
  String availableFrom2;
  @HiveField(11)
  String availableTo2;
  @HiveField(12)
  String itemStatus;
  @HiveField(13)
  String image;
  @HiveField(14)
  CartDetail cartDetail;
  @HiveField(15)
  String exactSrc;
  @HiveField(16)
  Availability availability;
  @HiveField(17)
  String showPrice;

  factory ACommonFoodItem.fromJson(Map<String, dynamic> json) =>
      ACommonFoodItem(
        id: json["id"] == null ? null : json["id"],
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        foodItem: json["food_item"] == null ? null : json["food_item"],
        description: json["description"] == null ? null : json["description"],
        price: json["price"] == null ? null : json["price"],
        sellingPrice:
            json["selling_price"] == null ? null : json["selling_price"],
        originalPrice:
            json["original_price"] == null ? null : json["original_price"],
        status: json["status"] == null ? null : json["status"],
        availableFrom:
            json["available_from"] == null ? null : json["available_from"],
        availableTo: json["available_to"] == null ? null : json["available_to"],
        availableFrom2:
            json["available_from2"] == null ? null : json["available_from2"],
        availableTo2:
            json["available_to2"] == null ? null : json["available_to2"],
        itemStatus: json["item_status"] == null ? null : json["item_status"],
        image: json["image"] == null ? null : json["image"],
        cartDetail: json["cart_detail"] == null
            ? null
            : CartDetail.fromJson(json["cart_detail"]),
        exactSrc: json["exact_src"] == null ? null : json["exact_src"],
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
        showPrice: json["show_price"] == null ? null : json["show_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "food_item": foodItem == null ? null : foodItem,
        "description": description == null ? null : description,
        "price": price == null ? null : price,
        "selling_price": sellingPrice == null ? null : sellingPrice,
        "original_price": originalPrice == null ? null : originalPrice,
        "status": status == null ? null : status,
        "available_from": availableFrom == null ? null : availableFrom,
        "available_to": availableTo == null ? null : availableTo,
        "available_from2": availableFrom2 == null ? null : availableFrom2,
        "available_to2": availableTo2 == null ? null : availableTo2,
        "item_status": itemStatus == null ? null : itemStatus,
        "image": image == null ? null : image,
        "cart_detail": cartDetail == null ? null : cartDetail.toJson(),
        "exact_src": exactSrc == null ? null : exactSrc,
        "availability": availability == null ? null : availability.toJson(),
        "show_price": showPrice == null ? null : showPrice,
      };
}

@HiveType()
class CartDetail {
  CartDetail({
    this.quantity,
    this.itemNote,
  });

  @HiveField(0)
  int quantity;
  @HiveField(1)
  dynamic itemNote;

  factory CartDetail.fromJson(Map<String, dynamic> json) => CartDetail(
        quantity: json["quantity"] == null ? null : json["quantity"],
        itemNote: json["item_note"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity == null ? null : quantity,
        "item_note": itemNote,
      };
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
