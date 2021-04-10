import 'package:flutter/material.dart';

class RestaurantItemModel {
  String title;
  String description;
  String image;
  String originalPrice;
  String offerPrice;
  bool favoriteStatus;
  bool showAddButton;
  bool addButtonStatus; // change grey color

  RestaurantItemModel({
    @required this.title,
    @required this.description,
    @required this.image,
    @required this.originalPrice,
    @required this.offerPrice,
    @required this.favoriteStatus,
    @required this.showAddButton,
    @required this.addButtonStatus,
  });
}
