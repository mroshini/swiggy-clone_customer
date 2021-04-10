// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_details_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantDetailsApiModelAdapter
    extends TypeAdapter<RestaurantDetailsApiModel> {
  @override
  RestaurantDetailsApiModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantDetailsApiModel(
      totalPages: fields[0] as int,
      aCateory: (fields[1] as List)?.cast<ACateory>(),
      restaurant: fields[2] as RestaurantData,
      catFoodItems: (fields[3] as List)?.cast<CommonCatFoodItem>(),
      aCart: fields[4] as CartQuantityPrice,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantDetailsApiModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalPages)
      ..writeByte(1)
      ..write(obj.aCateory)
      ..writeByte(2)
      ..write(obj.restaurant)
      ..writeByte(3)
      ..write(obj.catFoodItems)
      ..writeByte(4)
      ..write(obj.aCart);
  }

  @override
  int get typeId => restaurantDetailsApiModelAdaptertypeID;
}

class ACateoryAdapter extends TypeAdapter<ACateory> {
  @override
  ACateory read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ACateory(
      mainCat: fields[0] as int,
      foodCount: fields[1] as int,
      mainCatName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ACateory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.mainCat)
      ..writeByte(1)
      ..write(obj.foodCount)
      ..writeByte(2)
      ..write(obj.mainCatName);
  }

  @override
  int get typeId => aCateoryAdaptertypeID;
}

class RestaurantDataAdapter extends TypeAdapter<RestaurantData> {
  @override
  RestaurantData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantData(
      id: fields[0] as int,
      name: fields[1] as String,
      location: fields[2] as String,
      logo: fields[3] as String,
      partnerId: fields[4] as int,
      deliveryTime: fields[5] as dynamic,
      budget: fields[6] as dynamic,
      rating: fields[7] as dynamic,
      resDesc: fields[8] as String,
      mode: fields[9] as String,
      cuisine: fields[10] as String,
      favouriteStatus: fields[11] as bool,
      promoStatus: fields[12] as int,
      promocode: (fields[13] as List)?.cast<Promocode>(),
      cartExist: fields[14] as bool,
      src: fields[15] as String,
      availability: fields[16] as Availability,
      cuisineText: fields[17] as String,
      distance: fields[18] as dynamic,
      mapSrc: fields[19] as String,
      restaurantTiming: (fields[20] as List)?.cast<RestaurantTiming>(),
      freeDelivery: fields[21] as String,
      ratingCountText: fields[22] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantData obj) {
    writer
      ..writeByte(23)
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
      ..write(obj.favouriteStatus)
      ..writeByte(12)
      ..write(obj.promoStatus)
      ..writeByte(13)
      ..write(obj.promocode)
      ..writeByte(14)
      ..write(obj.cartExist)
      ..writeByte(15)
      ..write(obj.src)
      ..writeByte(16)
      ..write(obj.availability)
      ..writeByte(17)
      ..write(obj.cuisineText)
      ..writeByte(18)
      ..write(obj.distance)
      ..writeByte(19)
      ..write(obj.mapSrc)
      ..writeByte(20)
      ..write(obj.restaurantTiming)
      ..writeByte(21)
      ..write(obj.freeDelivery)
      ..writeByte(22)
      ..write(obj.ratingCountText);
  }

  @override
  int get typeId => restaurantDataAdaptertypeID;
}

class RestaurantTimingAdapter extends TypeAdapter<RestaurantTiming> {
  @override
  RestaurantTiming read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantTiming(
      dayId: fields[0] as int,
      startTime1: fields[1] as String,
      endTime1: fields[2] as String,
      startTime2: fields[3] as String,
      endTime2: fields[4] as String,
      dayStatus: fields[5] as String,
      fullDay: fields[6] as bool,
      day: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantTiming obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.dayId)
      ..writeByte(1)
      ..write(obj.startTime1)
      ..writeByte(2)
      ..write(obj.endTime1)
      ..writeByte(3)
      ..write(obj.startTime2)
      ..writeByte(4)
      ..write(obj.endTime2)
      ..writeByte(5)
      ..write(obj.dayStatus)
      ..writeByte(6)
      ..write(obj.fullDay)
      ..writeByte(7)
      ..write(obj.day);
  }

  @override
  int get typeId => restaurantTimingAdapterTypeID;
}

class PromocodeAdapter extends TypeAdapter<Promocode> {
  @override
  Promocode read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Promocode(
      id: fields[0] as int,
      promoName: fields[1] as String,
      promoDesc: fields[2] as String,
      promoType: fields[3] as String,
      promoAmount: fields[4] as int,
      minOrderValue: fields[5] as int,
      promoCodeText: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Promocode obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.promoName)
      ..writeByte(2)
      ..write(obj.promoDesc)
      ..writeByte(3)
      ..write(obj.promoType)
      ..writeByte(4)
      ..write(obj.promoAmount)
      ..writeByte(5)
      ..write(obj.minOrderValue)
      ..writeByte(6)
      ..write(obj.promoCodeText);
  }

  @override
  int get typeId => promocodeAdapterTypeID;
}
