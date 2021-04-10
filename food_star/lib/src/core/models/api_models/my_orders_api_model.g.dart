// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_orders_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AOrderAdapter extends TypeAdapter<AOrder> {
  @override
  AOrder read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AOrder(
      id: fields[0] as int,
      resId: fields[1] as int,
      createdAt: fields[2] as String,
      status: fields[3] as String,
      orderDetails: fields[4] as String,
      grandTotal: fields[5] as dynamic,
      restaurantInfo: fields[6] as RestaurantInfo,
      statusText: fields[7] as String,
      createdDateTime: fields[8] as String,
      foodAvailableCount: fields[9] as FoodAvailableCount,
      doPay: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AOrder obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.resId)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.orderDetails)
      ..writeByte(5)
      ..write(obj.grandTotal)
      ..writeByte(6)
      ..write(obj.restaurantInfo)
      ..writeByte(7)
      ..write(obj.statusText)
      ..writeByte(8)
      ..write(obj.createdDateTime)
      ..writeByte(9)
      ..write(obj.foodAvailableCount)
      ..writeByte(10)
      ..write(obj.doPay);
  }

  @override
  int get typeId => aOrderAdaptertypeID;
}

class RestaurantInfoAdapter extends TypeAdapter<RestaurantInfo> {
  @override
  RestaurantInfo read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantInfo(
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
      src: fields[11] as String,
      availability: fields[12] as Availability,
      cuisineText: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantInfo obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.src)
      ..writeByte(12)
      ..write(obj.availability)
      ..writeByte(13)
      ..write(obj.cuisineText);
  }

  @override
  int get typeId => restaurantInfoAdaptertypeID;
}

class FoodAvailableCountAdapter extends TypeAdapter<FoodAvailableCount> {
  @override
  FoodAvailableCount read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodAvailableCount(
      totalCount: fields[0] as int,
      availableCount: fields[1] as int,
      unavailableCount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FoodAvailableCount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.totalCount)
      ..writeByte(1)
      ..write(obj.availableCount)
      ..writeByte(2)
      ..write(obj.unavailableCount);
  }

  @override
  int get typeId => foodAvailableCountAdaptertypeID;
}
