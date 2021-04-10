import 'dart:convert';

OnlinePaymentApiModel onlinePaymentApiModelFromJson(str) =>
    OnlinePaymentApiModel.fromJson(json.decode(str));

String onlinePaymentApiModelToJson(OnlinePaymentApiModel data) =>
    json.encode(data.toJson());

class OnlinePaymentApiModel {
  String message;
  AOrder aOrder;

  OnlinePaymentApiModel({this.message, this.aOrder});

  OnlinePaymentApiModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    aOrder =
        json['aOrder'] != null ? new AOrder.fromJson(json['aOrder']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.aOrder != null) {
      data['aOrder'] = this.aOrder.toJson();
    }
    return data;
  }
}

class AOrder {
  dynamic id;
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
  dynamic onlinePayChanrge;
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
  dynamic paymentToken;
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

  AOrder(
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
      this.boyId});

  AOrder.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
