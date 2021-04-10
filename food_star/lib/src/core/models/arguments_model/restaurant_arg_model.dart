import 'package:foodstar/src/core/models/api_models/home_restaurant_list_api_model.dart';

class RestaurantsArgModel {
  final Restaurant restaurantData;
  final String imageTag;
  final int index;
  final String city;
  final int restaurantID;
  final String image;
  final int fromWhere;
  final int availabilityStatus;

  RestaurantsArgModel({
    this.restaurantData,
    this.imageTag,
    this.index,
    this.city,
    this.image,
    this.restaurantID,
    this.fromWhere,
    this.availabilityStatus, // 1- home, 2- search , 3- cart
  });
}
