import 'dart:convert';

PromoCodeApiModel promoCodeApiModelFromJson(str) =>
    PromoCodeApiModel.fromJson(json.decode(str));

String promoCodeApiModelToJson(PromoCodeApiModel data) =>
    json.encode(data.toJson());

class PromoCodeApiModel {
  List<APromocode> aPromocode;

  PromoCodeApiModel({this.aPromocode});

  PromoCodeApiModel.fromJson(Map<String, dynamic> json) {
    if (json['aPromocode'] != null) {
      aPromocode = new List<APromocode>();
      json['aPromocode'].forEach((v) {
        aPromocode.add(new APromocode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aPromocode != null) {
      data['aPromocode'] = this.aPromocode.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class APromocode {
  int id;
  String promoName;
  String promoDesc;
  String promoCode;
  String promoType;
  int promoAmount;
  int minOrderValue;
  String promoCodeText;

  APromocode(
      {this.id,
      this.promoName,
      this.promoDesc,
      this.promoCode,
      this.promoType,
      this.promoAmount,
      this.minOrderValue,
      this.promoCodeText});

  APromocode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promoName = json['promo_name'];
    promoDesc = json['promo_desc'];
    promoCode = json['promo_code'];
    promoType = json['promo_type'];
    promoAmount = json['promo_amount'];
    minOrderValue = json['min_order_value'];
    promoCodeText = json['promo_code_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['promo_name'] = this.promoName;
    data['promo_desc'] = this.promoDesc;
    data['promo_type'] = this.promoType;
    data['promo_code'] = this.promoCode;
    data['promo_amount'] = this.promoAmount;
    data['min_order_value'] = this.minOrderValue;
    data['promo_code_text'] = this.promoCodeText;
    return data;
  }
}
