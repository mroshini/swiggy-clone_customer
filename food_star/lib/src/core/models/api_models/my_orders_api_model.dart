import 'dart:convert';

import 'package:foodstar/src/core/service/hive_database/hive_type_ids.dart';
import 'package:hive/hive.dart';

import 'favorites_restaurant_api_model.dart';

part 'my_orders_api_model.g.dart';

MyOrdersApiModel myOrdersApiModelFromJson(str) =>
    MyOrdersApiModel.fromJson(json.decode(str));

String myOrdersApiModelToJson(MyOrdersApiModel data) =>
    json.encode(data.toJson());

class MyOrdersApiModel {
  @HiveType()
  List<AOrder> aOrder;

  MyOrdersApiModel({this.aOrder});

  MyOrdersApiModel.fromJson(Map<String, dynamic> json) {
    if (json['aOrder'] != null) {
      aOrder = new List<AOrder>();
      json['aOrder'].forEach((v) {
        aOrder.add(new AOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aOrder != null) {
      data['aOrder'] = this.aOrder.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType()
class AOrder {
  @HiveField(0)
  int id;
  @HiveField(1)
  int resId;
  @HiveField(2)
  String createdAt;
  @HiveField(3)
  String status;
  @HiveField(4)
  String orderDetails;
  @HiveField(5)
  dynamic grandTotal;
  @HiveField(6)
  RestaurantInfo restaurantInfo;
  @HiveField(7)
  String statusText;
  @HiveField(8)
  String createdDateTime;
  @HiveField(9)
  FoodAvailableCount foodAvailableCount;
  @HiveField(10)
  bool doPay;

  AOrder({
    this.id,
    this.resId,
    this.createdAt,
    this.status,
    this.orderDetails,
    this.grandTotal,
    this.restaurantInfo,
    this.statusText,
    this.createdDateTime,
    this.foodAvailableCount,
    this.doPay,
  });

  AOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resId = json['res_id'];
    createdAt = json['created_at'];
    status = json['status'];
    orderDetails = json['order_details'];
    grandTotal = json['grand_total'];
    restaurantInfo = json['restaurant_info'] != null
        ? new RestaurantInfo.fromJson(json['restaurant_info'])
        : null;
    statusText = json['status_text'];
    createdDateTime = json['created_date_time'];
    foodAvailableCount = json['food_available_count'] != null
        ? new FoodAvailableCount.fromJson(json['food_available_count'])
        : null;
    doPay = json['do_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['res_id'] = this.resId;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['order_details'] = this.orderDetails;
    data['grand_total'] = this.grandTotal;
    if (this.restaurantInfo != null) {
      data['restaurant_info'] = this.restaurantInfo.toJson();
    }
    data['status_text'] = this.statusText;
    data['created_date_time'] = this.createdDateTime;
    data['do_pay'] = this.doPay;
    if (this.foodAvailableCount != null) {
      data['food_available_count'] = this.foodAvailableCount.toJson();
    }
    return data;
  }
}

@HiveType()
class RestaurantInfo {
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
  String src;
  @HiveField(12)
  Availability availability;
  @HiveField(13)
  String cuisineText;

  RestaurantInfo(
      {this.id,
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
      this.src,
      this.availability,
      this.cuisineText});

  RestaurantInfo.fromJson(Map<String, dynamic> json) {
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
    src = json['src'];
    availability = json['availability'] != null
        ? new Availability.fromJson(json['availability'])
        : null;
    cuisineText = json['cuisine_text'];
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
    data['src'] = this.src;
    if (this.availability != null) {
      data['availability'] = this.availability.toJson();
    }
    data['cuisine_text'] = this.cuisineText;
    return data;
  }
}

//@HiveType()
//class Availability {
//  @HiveField(0)
//  int status;
//  @HiveField(1)
//  String text;
//
//  Availability({this.status, this.text});
//
//  Availability.fromJson(Map<String, dynamic> json) {
//    status = json['status'];
//    text = json['text'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['status'] = this.status;
//    data['text'] = this.text;
//    return data;
//  }
//}

@HiveType()
class FoodAvailableCount {
  @HiveField(0)
  int totalCount;
  @HiveField(1)
  int availableCount;
  @HiveField(2)
  int unavailableCount;

  FoodAvailableCount(
      {this.totalCount, this.availableCount, this.unavailableCount});

  FoodAvailableCount.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    availableCount = json['availableCount'];
    unavailableCount = json['unavailableCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['availableCount'] = this.availableCount;
    data['unavailableCount'] = this.unavailableCount;
    return data;
  }
}
