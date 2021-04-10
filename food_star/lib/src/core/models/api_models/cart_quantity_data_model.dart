//// To parse this JSON data, do
////
////     final restaurantDetailsApiModel = restaurantDetailsApiModelFromJson(jsonString);
//
////
////CartItemsDataModel cartItemsDataModelFromJson(str) =>
////    CartItemsDataModel.fromJson(json.decode(str));
////
////String cartItemsDataModelToJson(CartItemsDataModel data) =>
////    json.encode(data.toJson());
////
////class CartItemsDataModel {
////  CartItemsDataModel({
////    this.aCart,
////  });
////
////  CartQuantityPrice aCart;
////
////  factory CartItemsDataModel.fromJson(Map<String, dynamic> json) =>
////      CartItemsDataModel(
////        aCart: json["aCart"] == null
////            ? null
////            : CartQuantityPrice.fromJson(json["aCart"]),
////      );
////
////  Map<String, dynamic> toJson() => {
////        "aCart": aCart == null ? null : aCart.toJson(),
////      };
////}
//
//import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
//
//class CartActionDetails {
//  CartQuantityPrice aCart;
//  List<ACommonFoodItem> foodItemView;
//  String message;
//  Restaurant restaurant;
//
//  CartActionDetails({
//    this.aCart,
//    this.foodItemView,
//    this.message,
//    this.restaurant,
//  });
//
//  CartActionDetails.fromJson(Map<String, dynamic> json) {
//    aCart = json['aCart'] != null
//        ? new CartQuantityPrice.fromJson(json['aCart'])
//        : null;
//    if (json['food_item_view'] != null) {
//      foodItemView = new List<ACommonFoodItem>();
//      json['food_item_view'].forEach((v) {
//        foodItemView.add(new ACommonFoodItem.fromJson(v));
//      });
//    }
//    restaurant = json['restaurant'] != null
//        ? new Restaurant.fromJson(json['restaurant'])
//        : null;
//
//    message = json['message'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    if (this.aCart != null) {
//      data['aCart'] = this.aCart.toJson();
//    }
//    if (this.foodItemView != null) {
//      data['food_item_view'] =
//          this.foodItemView.map((v) => v.toJson()).toList();
//    }
//    if (this.restaurant != null) {
//      data['restaurant'] = this.restaurant.toJson();
//    }
//    data['message'] = this.message;
//    return data;
//  }
//}
//
//class Restaurant {
//  Restaurant({
//    this.id,
//    this.name,
//    this.location,
//    this.logo,
//    this.partnerId,
//    this.partnerCode,
//    this.minimumOrder,
//    this.openingTime,
//    this.closingTime,
//    this.phone,
//    this.serviceTax1,
//    this.serviceTax2,
//    this.freeDelivery,
//    this.deliveryCharge,
//    this.gst,
//    this.cuisine,
//    this.callHandling,
//    this.deliveryTime,
//    this.offer,
//    this.budget,
//    this.budgetOld,
//    this.rating,
//    this.entryBy,
//    this.latitude,
//    this.longitude,
//    this.flatno,
//    this.adrsLine1,
//    this.adrsLine2,
//    this.subLocLevel1,
//    this.city,
//    this.state,
//    this.country,
//    this.zipcode,
//    this.resDesc,
//    this.status,
//    this.commission,
//    this.adminStatus,
//    this.rejectreason,
//    this.tagline,
//    this.ordering,
//    this.mode,
//    this.modeFilter,
//    this.staticMapImage,
//    this.availability,
//  });
//
//  int id;
//  String name;
//  String location;
//  String logo;
//  int partnerId;
//  String partnerCode;
//  dynamic minimumOrder;
//  String openingTime;
//  String closingTime;
//  int phone;
//  int serviceTax1;
//  int serviceTax2;
//  String freeDelivery;
//  int deliveryCharge;
//  int gst;
//  String cuisine;
//  int callHandling;
//  int deliveryTime;
//  int offer;
//  int budget;
//  dynamic budgetOld;
//  int rating;
//  int entryBy;
//  double latitude;
//  double longitude;
//  String flatno;
//  String adrsLine1;
//  String adrsLine2;
//  String subLocLevel1;
//  String city;
//  String state;
//  String country;
//  String zipcode;
//  String resDesc;
//  String status;
//  String commission;
//  String adminStatus;
//  dynamic rejectreason;
//  String tagline;
//  int ordering;
//  String mode;
//  String modeFilter;
//  String staticMapImage;
//  Availability availability;
//
//  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
//        id: json["id"],
//        name: json["name"],
//        location: json["location"],
//        logo: json["logo"],
//        partnerId: json["partner_id"],
//        partnerCode: json["partner_code"],
//        minimumOrder: json["minimum_order"],
//        openingTime: json["opening_time"],
//        closingTime: json["closing_time"],
//        phone: json["phone"],
//        serviceTax1: json["service_tax1"],
//        serviceTax2: json["service_tax2"],
//        freeDelivery: json["free_delivery"],
//        deliveryCharge: json["delivery_charge"],
//        gst: json["gst"],
//        cuisine: json["cuisine"],
//        callHandling: json["call_handling"],
//        deliveryTime: json["delivery_time"],
//        offer: json["offer"],
//        budget: json["budget"],
//        budgetOld: json["budget_old"],
//        rating: json["rating"],
//        entryBy: json["entry_by"],
//        latitude: json["latitude"].toDouble(),
//        longitude: json["longitude"].toDouble(),
//        flatno: json["flatno"],
//        adrsLine1: json["adrs_line_1"],
//        adrsLine2: json["adrs_line_2"],
//        subLocLevel1: json["sub_loc_level_1"],
//        city: json["city"],
//        state: json["state"],
//        country: json["country"],
//        zipcode: json["zipcode"],
//        resDesc: json["res_desc"],
//        status: json["status"],
//        commission: json["commission"],
//        adminStatus: json["admin_status"],
//        rejectreason: json["rejectreason"],
//        tagline: json["tagline"],
//        ordering: json["ordering"],
//        mode: json["mode"],
//        modeFilter: json["mode_filter"],
//        staticMapImage: json["static_map_image"],
//        availability: Availability.fromJson(json["availability"]),
//      );
//
//  Map<String, dynamic> toJson() => {
//        "id": id,
//        "name": name,
//        "location": location,
//        "logo": logo,
//        "partner_id": partnerId,
//        "partner_code": partnerCode,
//        "minimum_order": minimumOrder,
//        "opening_time": openingTime,
//        "closing_time": closingTime,
//        "phone": phone,
//        "service_tax1": serviceTax1,
//        "service_tax2": serviceTax2,
//        "free_delivery": freeDelivery,
//        "delivery_charge": deliveryCharge,
//        "gst": gst,
//        "cuisine": cuisine,
//        "call_handling": callHandling,
//        "delivery_time": deliveryTime,
//        "offer": offer,
//        "budget": budget,
//        "budget_old": budgetOld,
//        "rating": rating,
//        "entry_by": entryBy,
//        "latitude": latitude,
//        "longitude": longitude,
//        "flatno": flatno,
//        "adrs_line_1": adrsLine1,
//        "adrs_line_2": adrsLine2,
//        "sub_loc_level_1": subLocLevel1,
//        "city": city,
//        "state": state,
//        "country": country,
//        "zipcode": zipcode,
//        "res_desc": resDesc,
//        "status": status,
//        "commission": commission,
//        "admin_status": adminStatus,
//        "rejectreason": rejectreason,
//        "tagline": tagline,
//        "ordering": ordering,
//        "mode": mode,
//        "mode_filter": modeFilter,
//        "static_map_image": staticMapImage,
//        "availability": availability.toJson(),
//      };
//}
//
////class CartQuantityPrice {
////  String totalQuantity;
////  int totalPrice;
////  String foodIds;
////
////  CartQuantityPrice({this.totalQuantity, this.totalPrice, this.foodIds});
////
////  CartQuantityPrice.fromJson(Map<String, dynamic> json) {
////    totalQuantity = json['total_quantity'];
////    totalPrice = json['total_price'];
////    foodIds = json['food_ids'];
////  }
////
////  Map<String, dynamic> toJson() {
////    final Map<String, dynamic> data = new Map<String, dynamic>();
////    data['total_quantity'] = this.totalQuantity;
////    data['total_price'] = this.totalPrice;
////    data['food_ids'] = this.foodIds;
////    return data;
////  }
////}
//
//class CartQuantityPrice {
//  CartQuantityPrice({
//    this.totalQuantity,
//    this.totalPrice,
//  });
//
//  dynamic totalQuantity;
//  dynamic totalPrice;
//
//  factory CartQuantityPrice.fromJson(Map<String, dynamic> json) =>
//      CartQuantityPrice(
//        totalQuantity: json["total_quantity"],
//        totalPrice: json["total_price"],
//      );
//
//  Map<String, dynamic> toJson() => {
//        "total_quantity": totalQuantity,
//        "total_price": totalPrice,
//      };
//}
