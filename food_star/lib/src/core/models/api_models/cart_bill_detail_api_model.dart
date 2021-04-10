// To parse this JSON data, do
//
//     final cartBillDetailsApiModel = cartBillDetailsApiModelFromJson(jsonString);

import 'dart:convert';

import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/service/hive_database/hive_type_ids.dart';
import 'package:hive/hive.dart';

import 'favorites_restaurant_api_model.dart';

part 'cart_bill_detail_api_model.g.dart';

CartBillDetailsApiModel cartBillDetailsApiModelFromJson(str) =>
    CartBillDetailsApiModel.fromJson(json.decode(str));

String cartBillDetailsApiModelToJson(CartBillDetailsApiModel data) =>
    json.encode(data.toJson());

@HiveType()
class CartBillDetailsApiModel {
  @HiveField(0)
  List<ACommonFoodItem> aCartItems;
  @HiveField(1)
  int addressId;
  @HiveField(2)
  String address;
  @HiveField(3)
  String distance;
  @HiveField(4)
  String durationText;
  @HiveField(5)
  dynamic itemPrice;
  @HiveField(6)
  dynamic promoamount;
  @HiveField(7)
  dynamic deliveryCharge;
  @HiveField(8)
  dynamic savedPrice;
  @HiveField(9)
  dynamic grandTotal;
  @HiveField(10)
  CartRestaurantData restaurant;
  @HiveField(11)
  int phoneNumber;
  @HiveField(12)
  String message;
  @HiveField(13)
  CartQuantityPrice aCart;
  @HiveField(14)
  AUser aUser;
  @HiveField(15)
  String unavailableFoodIds;
  @HiveField(16)
  int promoStatus;
  @HiveField(17)
  String selectedCouponCode;
  @HiveField(18)
  dynamic itemOfferPrice;
  @HiveField(19)
  dynamic stax1;
  @HiveField(20)
  dynamic deliveryChargeDiscount;
  @HiveField(21)
  dynamic delChargeTaxPrice;
  @HiveField(22)
  dynamic itemOriginalPrice;

  CartBillDetailsApiModel({
    this.aCartItems,
    this.addressId,
    this.address,
    this.distance,
    this.durationText,
    this.itemPrice,
    this.promoamount,
    this.deliveryCharge,
    this.savedPrice,
    this.grandTotal,
    this.restaurant,
    this.phoneNumber,
    this.message,
    this.aCart,
    this.aUser,
    this.unavailableFoodIds,
    this.promoStatus,
    this.selectedCouponCode,
    this.itemOfferPrice,
    this.stax1,
    this.deliveryChargeDiscount,
    this.delChargeTaxPrice,
    this.itemOriginalPrice,
  });

  CartBillDetailsApiModel.fromJson(Map<String, dynamic> json) {
    if (json['food_item_view'] != null) {
      aCartItems = new List<ACommonFoodItem>();
      json['food_item_view'].forEach((v) {
        aCartItems.add(new ACommonFoodItem.fromJson(v));
      });
    }
    addressId = json['address_id'];
    address = json['address'];
    distance = json['distance'];
    durationText = json['duration_text'];
    itemPrice = json['itemPrice'];
    promoamount = json['promoamount'];
    deliveryCharge = json['delivery_charge'];
    savedPrice = json['savedPrice'];
    grandTotal = json['grandTotal'];
    restaurant = json['restaurant'] != null
        ? new CartRestaurantData.fromJson(json['restaurant'])
        : null;
    phoneNumber = json['phone_number'];
    message = json['message'];
    aCart = json['aCart'] != null
        ? new CartQuantityPrice.fromJson(json['aCart'])
        : null;
    aUser = json['aUser'] != null ? new AUser.fromJson(json['aUser']) : null;
    unavailableFoodIds = json['unavailableFoodIds'];
    selectedCouponCode = json['selectedCouponCode'];
    itemOfferPrice = json['itemOfferPrice'];
    stax1 = json['stax1'];
    deliveryChargeDiscount = json['delivery_charge_discount'];
    delChargeTaxPrice = json['del_charge_tax_price'];
    itemOriginalPrice = json['itemOriginalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aCartItems != null) {
      data['food_item_view'] = this.aCartItems.map((v) => v.toJson()).toList();
    }
    if (this.aCart != null) {
      data['aCart'] = this.aCart.toJson();
    }
    if (this.aUser != null) {
      data['aUser'] = this.aUser.toJson();
    }
    data['address_id'] = this.addressId;
    data['address'] = this.address;
    data['distance'] = this.distance;
    data['duration_text'] = this.durationText;
    data['itemPrice'] = this.itemPrice;
    data['promoamount'] = this.promoamount;
    data['delivery_charge'] = this.deliveryCharge;
    data['savedPrice'] = this.savedPrice;
    data['grandTotal'] = this.grandTotal;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    data['phone_number'] = this.phoneNumber;
    data['message'] = this.message;
    data['promo_status'] = this.promoStatus;
    data['unavailableFoodIds'] = this.unavailableFoodIds;
    data['selectedCouponCode'] = this.selectedCouponCode;
    data['itemOfferPrice'] = this.itemOfferPrice;
    data['stax1'] = this.stax1;
    data['delivery_charge_discount'] = this.deliveryChargeDiscount;
    data['del_charge_tax_price'] = this.delChargeTaxPrice;
    data['itemOriginalPrice'] = this.itemOriginalPrice;
    return data;
  }
}

class AUser {
  String username;
  String email;
  int phoneNumber;

  AUser({this.username, this.email, this.phoneNumber});

  AUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

//class ACartItems {
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
//  ACartItems(
//      {this.id,
//      this.restaurantId,
//      this.foodItem,
//      this.description,
//      this.price,
//      this.sellingPrice,
//      this.originalPrice,
//      this.status,
//      this.availableFrom,
//      this.availableTo,
//      this.availableFrom2,
//      this.availableTo2,
//      this.itemStatus,
//      this.image,
//      this.cartDetail,
//      this.exactSrc,
//      this.availability,
//      this.showPrice});
//
//  ACartItems.fromJson(Map<String, dynamic> json) {
//    id = json['id'];
//    restaurantId = json['restaurant_id'];
//    foodItem = json['food_item'];
//    description = json['description'];
//    price = json['price'];
//    sellingPrice = json['selling_price'];
//    originalPrice = json['original_price'];
//    status = json['status'];
//    availableFrom = json['available_from'];
//    availableTo = json['available_to'];
//    availableFrom2 = json['available_from2'];
//    availableTo2 = json['available_to2'];
//    itemStatus = json['item_status'];
//    image = json['image'];
//    cartDetail = json['cart_detail'] != null
//        ? new CartDetail.fromJson(json['cart_detail'])
//        : null;
//    exactSrc = json['exact_src'];
//    availability = json['availability'] != null
//        ? new Availability.fromJson(json['availability'])
//        : null;
//    showPrice = json['show_price'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['id'] = this.id;
//    data['restaurant_id'] = this.restaurantId;
//    data['food_item'] = this.foodItem;
//    data['description'] = this.description;
//    data['price'] = this.price;
//    data['selling_price'] = this.sellingPrice;
//    data['original_price'] = this.originalPrice;
//    data['status'] = this.status;
//    data['available_from'] = this.availableFrom;
//    data['available_to'] = this.availableTo;
//    data['available_from2'] = this.availableFrom2;
//    data['available_to2'] = this.availableTo2;
//    data['item_status'] = this.itemStatus;
//    data['image'] = this.image;
//    if (this.cartDetail != null) {
//      data['cart_detail'] = this.cartDetail.toJson();
//    }
//    data['exact_src'] = this.exactSrc;
//    if (this.availability != null) {
//      data['availability'] = this.availability.toJson();
//    }
//    data['show_price'] = this.showPrice;
//    return data;
//  }
//}

//class CartDetail {
//  int quantity;
//  String itemNote;
//
//  CartDetail({this.quantity, this.itemNote});
//
//  CartDetail.fromJson(Map<String, dynamic> json) {
//    quantity = json['quantity'];
//    itemNote = json['item_note'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['quantity'] = this.quantity;
//    data['item_note'] = this.itemNote;
//    return data;
//  }
//}

//class Availability {
//  int status;
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
class CartRestaurantData {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String logo;
  @HiveField(3)
  String location;
  @HiveField(4)
  int deliveryTime;
  @HiveField(5)
  String mode;
  @HiveField(6)
  String src;
  @HiveField(7)
  Availability availability;
  @HiveField(8)
  int minimumOrder;
  @HiveField(9)
  String freeDelivery;
  @HiveField(10)
  String city;
  @HiveField(11)
  double latitude;
  @HiveField(12)
  double longitude;
  @HiveField(13)
  int promoStatus;

  CartRestaurantData({
    this.id,
    this.name,
    this.logo,
    this.location,
    this.deliveryTime,
    this.mode,
    this.src,
    this.availability,
    this.minimumOrder,
    this.freeDelivery,
    this.city,
    this.longitude,
    this.latitude,
    this.promoStatus,
  });

  CartRestaurantData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    location = json['location'];
    deliveryTime = json['delivery_time'];
    mode = json['mode'];
    src = json['src'];
    minimumOrder = json['minimum_order'];
    freeDelivery = json['free_delivery'];
    availability = json['availability'] != null
        ? new Availability.fromJson(json['availability'])
        : null;
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    promoStatus = json['promo_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['location'] = this.location;
    data['delivery_time'] = this.deliveryTime;
    data['mode'] = this.mode;
    data['src'] = this.src;
    data['minimum_order'] = this.minimumOrder;
    data['free_delivery'] = this.freeDelivery;
    data['city'] = this.city;
    if (this.availability != null) {
      data['availability'] = this.availability.toJson();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['promo_status'] = this.promoStatus;
    return data;
  }
}
