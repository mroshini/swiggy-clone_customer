// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantDetailAdapter extends TypeAdapter<RestaurantDetail> {
  @override
  RestaurantDetail read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantDetail(
      id: fields[0] as int,
      name: fields[1] as String,
      cuisine: fields[2] as String,
      rating: fields[3] as int,
      deliveryTime: fields[4] as int,
      mode: fields[5] as String,
      cartExist: fields[6] as bool,
      availability: fields[7] as Availability,
      cuisineText: fields[8] as String,
      src: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantDetail obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.cuisine)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.deliveryTime)
      ..writeByte(5)
      ..write(obj.mode)
      ..writeByte(6)
      ..write(obj.cartExist)
      ..writeByte(7)
      ..write(obj.availability)
      ..writeByte(8)
      ..write(obj.cuisineText)
      ..writeByte(9)
      ..write(obj.src);
  }

  @override
  int get typeId => restaurantDetailAdapterID;
}
