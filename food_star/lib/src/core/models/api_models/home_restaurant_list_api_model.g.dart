// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_restaurant_list_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeRestaurantListApiModelAdapter
    extends TypeAdapter<HomeRestaurantListApiModel> {
  @override
  HomeRestaurantListApiModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeRestaurantListApiModel(
      restaurant: (fields[0] as List)?.cast<Restaurant>(),
      restaurantCount: fields[1] as int,
      totalPages: fields[2] as int,
      aSlider: (fields[3] as List)?.cast<ASlider>(),
      demo: fields[4] as int,
      aFilter: (fields[6] as List)?.cast<AFilter>(),
      restaurantCities: (fields[5] as List)?.cast<RestaurantCity>(),
      aCart: fields[7] as CartQuantityPrice,
      aCuisines: (fields[8] as List)?.cast<ACuisines>(),
    );
  }

  @override
  void write(BinaryWriter writer, HomeRestaurantListApiModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.restaurant)
      ..writeByte(1)
      ..write(obj.restaurantCount)
      ..writeByte(2)
      ..write(obj.totalPages)
      ..writeByte(3)
      ..write(obj.aSlider)
      ..writeByte(4)
      ..write(obj.demo)
      ..writeByte(5)
      ..write(obj.restaurantCities)
      ..writeByte(6)
      ..write(obj.aFilter)
      ..writeByte(7)
      ..write(obj.aCart)
      ..writeByte(8)
      ..write(obj.aCuisines);
  }

  @override
  int get typeId => homeRestaurantListApiModelAdaptertypeID;
}

class AFilterAdapter extends TypeAdapter<AFilter> {
  @override
  AFilter read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AFilter(
      filterName: fields[0] as String,
      filterValues: (fields[1] as List)?.cast<FilterValue>(),
    );
  }

  @override
  void write(BinaryWriter writer, AFilter obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.filterName)
      ..writeByte(1)
      ..write(obj.filterValues);
  }

  @override
  int get typeId => aFilterAdaptertypeID;
}

class FilterValueAdapter extends TypeAdapter<FilterValue> {
  @override
  FilterValue read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilterValue(
      id: fields[0] as int,
      name: fields[1] as String,
      src: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FilterValue obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.src);
  }

  @override
  int get typeId => filterValueAdaptertypeID;
}

class ASliderAdapter extends TypeAdapter<ASlider> {
  @override
  ASlider read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ASlider(
      id: fields[0] as int,
      image: fields[1] as String,
      src: fields[2] as String,
      type: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ASlider obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.src)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get typeId => aSliderAdaptertypeID;
}

class ACuisinesAdapter extends TypeAdapter<ACuisines> {
  @override
  ACuisines read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ACuisines(
      id: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String,
      src: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ACuisines obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.src);
  }

  @override
  int get typeId => aCuisinesAdapterID;
}

class RestaurantAdapter extends TypeAdapter<Restaurant> {
  @override
  Restaurant read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Restaurant(
      id: fields[0] as int,
      name: fields[1] as String,
      location: fields[2] as String,
      logo: fields[3] as String,
      partnerId: fields[4] as int,
      deliveryTime: fields[5] as dynamic,
      budget: fields[6] as int,
      rating: fields[7] as dynamic,
      resDesc: fields[8] as String,
      mode: fields[9] as String,
      distance: fields[11] as dynamic,
      cuisine: fields[10] as String,
      promoStatus: fields[12] as int,
      favouriteStatus: fields[13] as bool,
      src: fields[14] as String,
      availability: fields[15] as Availability,
      cuisineText: fields[16] as String,
      restaurantDetails: fields[17] as RestaurantDetailsApiModel,
      minimumOrder: fields[18] as dynamic,
      freeDelivery: fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Restaurant obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.logo)
      ..writeByte(4)
      ..write(obj.partnerId)
      ..writeByte(5)
      ..write(obj.deliveryTime)
      ..writeByte(6)
      ..write(obj.budget)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.resDesc)
      ..writeByte(9)
      ..write(obj.mode)
      ..writeByte(10)
      ..write(obj.cuisine)
      ..writeByte(11)
      ..write(obj.distance)
      ..writeByte(12)
      ..write(obj.promoStatus)
      ..writeByte(13)
      ..write(obj.favouriteStatus)
      ..writeByte(14)
      ..write(obj.src)
      ..writeByte(15)
      ..write(obj.availability)
      ..writeByte(16)
      ..write(obj.cuisineText)
      ..writeByte(17)
      ..write(obj.restaurantDetails)
      ..writeByte(18)
      ..write(obj.minimumOrder)
      ..writeByte(19)
      ..write(obj.freeDelivery);
  }

  @override
  int get typeId => restaurantAdaptertypeID;
}

class RestaurantCityAdapter extends TypeAdapter<RestaurantCity> {
  @override
  RestaurantCity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantCity(
      city: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantCity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.city);
  }

  @override
  int get typeId => restaurantCityAdaptertypeID;
}
