import 'dart:convert';

TrackOrderApiModel trackOrderApiModelFromJson(str) =>
    TrackOrderApiModel.fromJson(json.decode(str));

String trackOrderApiModelToJson(TrackOrderApiModel data) =>
    json.encode(data.toJson());

class TrackOrderApiModel {
  AOrder aOrder;

  TrackOrderApiModel({this.aOrder});

  TrackOrderApiModel.fromJson(Map<String, dynamic> json) {
    aOrder =
        json['aOrder'] != null ? new AOrder.fromJson(json['aOrder']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aOrder != null) {
      data['aOrder'] = this.aOrder.toJson();
    }
    return data;
  }
}

class AOrder {
  dynamic id;
  dynamic resId;
  dynamic custId;
  dynamic partnerId;
  dynamic boyId;
  dynamic createdAt;
  dynamic status;
  dynamic orderDetails;
  dynamic address;
  dynamic totalPrice;
  dynamic itemStrikePriceTotal;
  dynamic offerPrice;
  dynamic sTax1;
  dynamic delCharge;
  dynamic delChargeDiscount;
  dynamic delChargeTaxPrice;
  dynamic couponPrice;
  dynamic grandTotal;
  dynamic orderid;
  dynamic lat;
  dynamic lang;
  String orderNote;
  RestaurantDetail restaurantDetail;
  dynamic discountPrice;
  dynamic orderTime;
  dynamic orderRecieveText;
  dynamic driverStatusText;
  BoyDetail boyDetail;
  dynamic statusText;
  List<OrderItems> orderItems;

  AOrder(
      {this.id,
      this.resId,
      this.custId,
      this.partnerId,
      this.boyId,
      this.createdAt,
      this.status,
      this.orderDetails,
      this.address,
      this.totalPrice,
      this.itemStrikePriceTotal,
      this.offerPrice,
      this.sTax1,
      this.delCharge,
      this.delChargeDiscount,
      this.delChargeTaxPrice,
      this.couponPrice,
      this.grandTotal,
      this.orderid,
      this.lat,
      this.lang,
      this.orderNote,
      this.restaurantDetail,
      this.discountPrice,
      this.orderTime,
      this.orderRecieveText,
      this.driverStatusText,
      this.boyDetail,
      this.statusText,
      this.orderItems});

  AOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resId = json['res_id'];
    custId = json['cust_id'];
    partnerId = json['partner_id'];
    boyId = json['boy_id'];
    createdAt = json['created_at'];
    status = json['status'];
    orderDetails = json['order_details'];
    address = json['address'];
    totalPrice = json['total_price'];
    itemStrikePriceTotal = json['item_strike_price_total'];
    offerPrice = json['offer_price'];
    sTax1 = json['s_tax1'];
    delCharge = json['del_charge'];
    delChargeDiscount = json['del_charge_discount'];
    delChargeTaxPrice = json['del_charge_tax_price'];
    couponPrice = json['coupon_price'];
    grandTotal = json['grand_total'];
    orderid = json['orderid'];
    lat = json['lat'];
    lang = json['lang'];
    restaurantDetail = json['restaurant_detail'] != null
        ? new RestaurantDetail.fromJson(json['restaurant_detail'])
        : null;
    discountPrice = json['discount_price'];
    orderTime = json['order_time'];
    orderRecieveText = json['order_recieve_text'];
    driverStatusText = json['driver_status_text'];
    boyDetail = json['boy_detail'] != null
        ? new BoyDetail.fromJson(json['boy_detail'])
        : null;
    statusText = json['status_text'];
    orderNote = json['order_note'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['res_id'] = this.resId;
    data['cust_id'] = this.custId;
    data['partner_id'] = this.partnerId;
    data['boy_id'] = this.boyId;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['order_details'] = this.orderDetails;
    data['address'] = this.address;
    data['total_price'] = this.totalPrice;
    data['item_strike_price_total'] = this.itemStrikePriceTotal;
    data['offer_price'] = this.offerPrice;
    data['s_tax1'] = this.sTax1;
    data['del_charge'] = this.delCharge;
    data['del_charge_discount'] = this.delChargeDiscount;
    data['del_charge_tax_price'] = this.delChargeTaxPrice;
    data['coupon_price'] = this.couponPrice;
    data['grand_total'] = this.grandTotal;
    data['orderid'] = this.orderid;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['order_note'] = this.orderNote;
    if (this.restaurantDetail != null) {
      data['restaurant_detail'] = this.restaurantDetail.toJson();
    }
    data['discount_price'] = this.discountPrice;
    data['order_time'] = this.orderTime;
    data['order_recieve_text'] = this.orderRecieveText;
    data['driver_status_text'] = this.driverStatusText;
    if (this.boyDetail != null) {
      data['boy_detail'] = this.boyDetail.toJson();
    }
    data['status_text'] = this.statusText;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantDetail {
  dynamic name;
  dynamic location;
  dynamic latitude;
  dynamic longitude;

  RestaurantDetail({this.name, this.location, this.latitude, this.longitude});

  RestaurantDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class BoyDetail {
  dynamic username;
  dynamic phoneCode;
  dynamic phoneNumber;
  dynamic avatar;
  dynamic latitude;
  dynamic longitude;
  dynamic src;

  BoyDetail(
      {this.username,
      this.phoneCode,
      this.phoneNumber,
      this.avatar,
      this.latitude,
      this.longitude,
      this.src});

  BoyDetail.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phone_code'] = this.phoneCode;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['src'] = this.src;
    return data;
  }
}

class OrderItems {
  dynamic id;
  dynamic orderid;
  dynamic foodId;
  dynamic foodItem;
  dynamic quantity;
  dynamic price;
  dynamic vendorPrice;
  dynamic itemNote;
  dynamic originalPrice;

  OrderItems(
      {this.id,
      this.orderid,
      this.foodId,
      this.foodItem,
      this.quantity,
      this.price,
      this.vendorPrice,
      this.itemNote,
      this.originalPrice});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderid = json['orderid'];
    foodId = json['food_id'];
    foodItem = json['food_item'];
    quantity = json['quantity'];
    price = json['price'];
    vendorPrice = json['vendor_price'];
    itemNote = json['item_note'];
    originalPrice = json['original_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderid'] = this.orderid;
    data['food_id'] = this.foodId;
    data['food_item'] = this.foodItem;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['vendor_price'] = this.vendorPrice;
    data['item_note'] = this.itemNote;
    data['original_price'] = this.originalPrice;
    return data;
  }
}
