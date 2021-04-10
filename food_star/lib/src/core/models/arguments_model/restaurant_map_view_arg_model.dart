import 'package:foodstar/src/core/models/api_models/restaurant_details_api_model.dart';

class RestaurantsMapViewArgModel {
  final String restaurantName;
  final String description;
  final dynamic rating;
  final dynamic distance;
  final dynamic timing;
  final String location;
  final String mapImage;
  final String availabilityStatus;
  final String nextAvailabilityText;
  final List<RestaurantTiming> restaurantTiming;

  RestaurantsMapViewArgModel(
      {this.restaurantName,
      this.description,
      this.rating,
      this.distance,
      this.timing,
      this.location,
      this.mapImage,
      this.availabilityStatus,
      this.nextAvailabilityText,
      this.restaurantTiming});
}
