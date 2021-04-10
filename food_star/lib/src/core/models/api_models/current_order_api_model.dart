import 'dart:convert';

CurrentOrderApiModel currentOrderApiModelFromJson(str) =>
    CurrentOrderApiModel.fromJson(json.decode(str));

String commonErrorModelToJson(CurrentOrderApiModel data) =>
    json.encode(data.toJson());

class CurrentOrderApiModel {
  List<ATrackOrder> aTrackOrder;

  List<ATrackOrder> aPayOrder;

  CurrentOrderApiModel({this.aTrackOrder, this.aPayOrder});

  CurrentOrderApiModel.fromJson(Map<String, dynamic> json) {
    if (json['aTrackOrder'] != null) {
      aTrackOrder = new List<ATrackOrder>();
      json['aTrackOrder'].forEach((v) {
        aTrackOrder.add(new ATrackOrder.fromJson(v));
      });
    }
    if (json['aPayOrder'] != null) {
      aPayOrder = new List<ATrackOrder>();
      json['aPayOrder'].forEach((v) {
        aPayOrder.add(new ATrackOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aTrackOrder != null) {
      data['aTrackOrder'] = this.aTrackOrder.map((v) => v.toJson()).toList();
    }
    if (this.aPayOrder != null) {
      data['aPayOrder'] = this.aPayOrder.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ATrackOrder {
  int id;
  dynamic custId;
  dynamic resId;
  dynamic partnerId;
  String orderid;
  String mobileNum;
  dynamic totalPrice;
  dynamic hostWithcommission;
  dynamic hostAmount;
  dynamic adminCamount;
  String delKm;
  dynamic delCharge;
  dynamic fDelCharge;
  dynamic addDelCharge;
  String minNight;
  dynamic boyDelCharge;
  dynamic adminDelCharge;
  dynamic sTax1;
  String onlinePayChanrge;
  dynamic sTax2;
  dynamic comsnPercentage;
  dynamic offerPrice;
  dynamic offerPercentage;
  dynamic couponPrice;
  String couponType;
  dynamic couponValue;
  dynamic grandTotal;
  String address;
  String building;
  String landmark;
  String status;
  dynamic couponId;
  dynamic time;
  String date;
  String delivery;
  String deliveryType;
  dynamic lat;
  dynamic lang;
  String orderNote;
  dynamic skipStatus;
  String paymentToken;
  dynamic molStatus;
  dynamic couponMinVal;
  String cancelledBy;
  dynamic acceptedTime;
  dynamic dispatchedTime;
  dynamic completedTime;
  dynamic cancelledTime;
  dynamic duration;
  dynamic deliveryTime;
  String device;
  String orderValue;
  String orderDetails;
  String createdAt;
  String updatedAt;
  dynamic deliveryPreference;
  dynamic ordertype;
  dynamic laterDeliverDate;
  dynamic laterDeliverTime;
  dynamic freeDelivery;
  dynamic boyId;
  dynamic refundId;
  dynamic refundStatus;

  // RestaurantInfo restaurantInfo;
  String statusText;
  String createdDateTime;

  // FoodAvailableCount foodAvailableCount;
  bool ongoingStatus;
  bool doPay;

  ATrackOrder(
      {this.id,
      this.custId,
      this.resId,
      this.partnerId,
      this.orderid,
      this.mobileNum,
      this.totalPrice,
      this.hostWithcommission,
      this.hostAmount,
      this.adminCamount,
      this.delKm,
      this.delCharge,
      this.fDelCharge,
      this.addDelCharge,
      this.minNight,
      this.boyDelCharge,
      this.adminDelCharge,
      this.sTax1,
      this.onlinePayChanrge,
      this.sTax2,
      this.comsnPercentage,
      this.offerPrice,
      this.offerPercentage,
      this.couponPrice,
      this.couponType,
      this.couponValue,
      this.grandTotal,
      this.address,
      this.building,
      this.landmark,
      this.status,
      this.couponId,
      this.time,
      this.date,
      this.delivery,
      this.deliveryType,
      this.lat,
      this.lang,
      this.orderNote,
      this.skipStatus,
      this.paymentToken,
      this.molStatus,
      this.couponMinVal,
      this.cancelledBy,
      this.acceptedTime,
      this.dispatchedTime,
      this.completedTime,
      this.cancelledTime,
      this.duration,
      this.deliveryTime,
      this.device,
      this.orderValue,
      this.orderDetails,
      this.createdAt,
      this.updatedAt,
      this.deliveryPreference,
      this.ordertype,
      this.laterDeliverDate,
      this.laterDeliverTime,
      this.freeDelivery,
      this.boyId,
      this.refundId,
      this.refundStatus,
      //this.restaurantInfo,
      this.statusText,
      this.createdDateTime,
      //this.foodAvailableCount,
      this.ongoingStatus,
      this.doPay});

  ATrackOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    custId = json['cust_id'];
    resId = json['res_id'];
    partnerId = json['partner_id'];
    orderid = json['orderid'];
    mobileNum = json['mobile_num'];
    totalPrice = json['total_price'];
    hostWithcommission = json['host_withcommission'];
    hostAmount = json['host_amount'];
    adminCamount = json['admin_camount'];
    delKm = json['del_km'];
    delCharge = json['del_charge'];
    fDelCharge = json['f_del_charge'];
    addDelCharge = json['add_del_charge'];
    minNight = json['min_night'];
    boyDelCharge = json['boy_del_charge'];
    adminDelCharge = json['admin_del_charge'];
    sTax1 = json['s_tax1'];
    onlinePayChanrge = json['online_pay_chanrge'];
    sTax2 = json['s_tax2'];
    comsnPercentage = json['comsn_percentage'];
    offerPrice = json['offer_price'];
    offerPercentage = json['offer_percentage'];
    couponPrice = json['coupon_price'];
    couponType = json['coupon_type'];
    couponValue = json['coupon_value'];
    grandTotal = json['grand_total'];
    address = json['address'];
    building = json['building'];
    landmark = json['landmark'];
    status = json['status'];
    couponId = json['coupon_id'];
    time = json['time'];
    date = json['date'];
    delivery = json['delivery'];
    deliveryType = json['delivery_type'];
    lat = json['lat'];
    lang = json['lang'];
    orderNote = json['order_note'];
    skipStatus = json['skip_status'];
    paymentToken = json['payment_token'];
    molStatus = json['mol_status'];
    couponMinVal = json['coupon_min_val'];
    cancelledBy = json['cancelled_by'];
    acceptedTime = json['accepted_time'];
    dispatchedTime = json['dispatched_time'];
    completedTime = json['completed_time'];
    cancelledTime = json['cancelled_time'];
    duration = json['duration'];
    deliveryTime = json['delivery_time'];
    device = json['device'];
    orderValue = json['order_value'];
    orderDetails = json['order_details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryPreference = json['delivery_preference'];
    ordertype = json['ordertype'];
    laterDeliverDate = json['later_deliver_date'];
    laterDeliverTime = json['later_deliver_time'];
    freeDelivery = json['free_delivery'];
    boyId = json['boy_id'];
    refundId = json['refund_id'];
    refundStatus = json['refund_status'];
//    restaurantInfo = json['restaurant_info'] != null
//        ? new RestaurantInfo.fromJson(json['restaurant_info'])
//        : null;
    statusText = json['status_text'];
    createdDateTime = json['created_date_time'];
//    foodAvailableCount = json['food_available_count'] != null
//        ? new FoodAvailableCount.fromJson(json['food_available_count'])
//        : null;
    ongoingStatus = json['ongoing_status'];
    doPay = json['do_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cust_id'] = this.custId;
    data['res_id'] = this.resId;
    data['partner_id'] = this.partnerId;
    data['orderid'] = this.orderid;
    data['mobile_num'] = this.mobileNum;
    data['total_price'] = this.totalPrice;
    data['host_withcommission'] = this.hostWithcommission;
    data['host_amount'] = this.hostAmount;
    data['admin_camount'] = this.adminCamount;
    data['del_km'] = this.delKm;
    data['del_charge'] = this.delCharge;
    data['f_del_charge'] = this.fDelCharge;
    data['add_del_charge'] = this.addDelCharge;
    data['min_night'] = this.minNight;
    data['boy_del_charge'] = this.boyDelCharge;
    data['admin_del_charge'] = this.adminDelCharge;
    data['s_tax1'] = this.sTax1;
    data['online_pay_chanrge'] = this.onlinePayChanrge;
    data['s_tax2'] = this.sTax2;
    data['comsn_percentage'] = this.comsnPercentage;
    data['offer_price'] = this.offerPrice;
    data['offer_percentage'] = this.offerPercentage;
    data['coupon_price'] = this.couponPrice;
    data['coupon_type'] = this.couponType;
    data['coupon_value'] = this.couponValue;
    data['grand_total'] = this.grandTotal;
    data['address'] = this.address;
    data['building'] = this.building;
    data['landmark'] = this.landmark;
    data['status'] = this.status;
    data['coupon_id'] = this.couponId;
    data['time'] = this.time;
    data['date'] = this.date;
    data['delivery'] = this.delivery;
    data['delivery_type'] = this.deliveryType;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['order_note'] = this.orderNote;
    data['skip_status'] = this.skipStatus;
    data['payment_token'] = this.paymentToken;
    data['mol_status'] = this.molStatus;
    data['coupon_min_val'] = this.couponMinVal;
    data['cancelled_by'] = this.cancelledBy;
    data['accepted_time'] = this.acceptedTime;
    data['dispatched_time'] = this.dispatchedTime;
    data['completed_time'] = this.completedTime;
    data['cancelled_time'] = this.cancelledTime;
    data['duration'] = this.duration;
    data['delivery_time'] = this.deliveryTime;
    data['device'] = this.device;
    data['order_value'] = this.orderValue;
    data['order_details'] = this.orderDetails;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_preference'] = this.deliveryPreference;
    data['ordertype'] = this.ordertype;
    data['later_deliver_date'] = this.laterDeliverDate;
    data['later_deliver_time'] = this.laterDeliverTime;
    data['free_delivery'] = this.freeDelivery;
    data['boy_id'] = this.boyId;
    data['refund_id'] = this.refundId;
    data['refund_status'] = this.refundStatus;
//    if (this.restaurantInfo != null) {
//      data['restaurant_info'] = this.restaurantInfo.toJson();
//    }
    data['status_text'] = this.statusText;
    data['created_date_time'] = this.createdDateTime;
//    if (this.foodAvailableCount != null) {
//      data['food_available_count'] = this.foodAvailableCount.toJson();
//    }
    data['ongoing_status'] = this.ongoingStatus;
    data['do_pay'] = this.doPay;
    return data;
  }
}

//class RestaurantInfo {
//  int id;
//  String name;
//  String location;
//  String logo;
//  int partnerId;
//  int deliveryTime;
//  int budget;
//  int rating;
//  String resDesc;
//  String mode;
//  String cuisine;
//  String src;
//  Availability availability;
//  String cuisineText;
//
//  RestaurantInfo(
//      {this.id,
//      this.name,
//      this.location,
//      this.logo,
//      this.partnerId,
//      this.deliveryTime,
//      this.budget,
//      this.rating,
//      this.resDesc,
//      this.mode,
//      this.cuisine,
//      this.src,
//      this.availability,
//      this.cuisineText});
//
//  RestaurantInfo.fromJson(Map<String, dynamic> json) {
//    id = json['id'];
//    name = json['name'];
//    location = json['location'];
//    logo = json['logo'];
//    partnerId = json['partner_id'];
//    deliveryTime = json['delivery_time'];
//    budget = json['budget'];
//    rating = json['rating'];
//    resDesc = json['res_desc'];
//    mode = json['mode'];
//    cuisine = json['cuisine'];
//    src = json['src'];
//    availability = json['availability'] != null
//        ? new Availability.fromJson(json['availability'])
//        : null;
//    cuisineText = json['cuisine_text'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['id'] = this.id;
//    data['name'] = this.name;
//    data['location'] = this.location;
//    data['logo'] = this.logo;
//    data['partner_id'] = this.partnerId;
//    data['delivery_time'] = this.deliveryTime;
//    data['budget'] = this.budget;
//    data['rating'] = this.rating;
//    data['res_desc'] = this.resDesc;
//    data['mode'] = this.mode;
//    data['cuisine'] = this.cuisine;
//    data['src'] = this.src;
//    if (this.availability != null) {
//      data['availability'] = this.availability.toJson();
//    }
//    data['cuisine_text'] = this.cuisineText;
//    return data;
//  }
//}
//
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
//
//class FoodAvailableCount {
//  int totalCount;
//  int availableCount;
//  int unavailableCount;
//
//  FoodAvailableCount(
//      {this.totalCount, this.availableCount, this.unavailableCount});
//
//  FoodAvailableCount.fromJson(Map<String, dynamic> json) {
//    totalCount = json['totalCount'];
//    availableCount = json['availableCount'];
//    unavailableCount = json['unavailableCount'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['totalCount'] = this.totalCount;
//    data['availableCount'] = this.availableCount;
//    data['unavailableCount'] = this.unavailableCount;
//    return data;
//  }
//}
