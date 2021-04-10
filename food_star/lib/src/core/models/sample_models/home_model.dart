import 'package:flutter/material.dart';

class HomeInfo {
  String lineOne;
  String lineTwo;
  String image;
  String rating;
  String distance;
  String timing;
  int shopStatus;

  HomeInfo({
    @required this.lineOne,
    @required this.lineTwo,
    @required this.image,
    this.rating = " ",
    this.distance = " ",
    this.timing = " ",
    @required this.shopStatus,
  });
}
