import 'package:flutter/material.dart';

class MyOrdersModel {
  String title;
  String description;
  String image;
  String date;
  String orderStatus;
  String totalItem;
  String price;
  int availableStatus; //order again or closed

  MyOrdersModel({
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.image,
    @required this.orderStatus,
    @required this.totalItem,
    @required this.price,
    @required this.availableStatus,
  });
}
