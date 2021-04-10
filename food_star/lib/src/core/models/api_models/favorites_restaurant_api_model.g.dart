// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_restaurant_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ARestaurantAdapter extends TypeAdapter<ARestaurant> {
  @override
  ARestaurant read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ARestaurant(
      id: fields[0] as int,
      name: fields[1] as String,
      location: fields[2] as String,
      logo: fields[3] as String,
      partnerId: fields[4] as int,
      deliveryTime: fields[5] as int,
      budget: fields[6] as int,
      rating: fields[7] as int,
      resDesc: fields[8] as String,
      mode: fields[9] as String,
      cuisine: fields[10] as String,
      promoStatus: fields[11] as int,
      favouriteStatus: fields[12] as dynamic,
      cartExist: fields[13] as bool,
      src: fields[14] as String,
      availability: fields[15] as Availability,
      cuisineText: fields[16] as String,
      city: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ARestaurant obj) {
    writer
      ..writeByte(18)
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
      ..write(obj.promoStatus)
      ..writeByte(12)
      ..write(obj.favouriteStatus)
      ..writeByte(13)
      ..write(obj.cartExist)
      ..writeByte(14)
      ..write(obj.src)
      ..writeByte(15)
      ..write(obj.availability)
      ..writeByte(16)
      ..write(obj.cuisineText)
      ..writeByte(17)
      ..write(obj.city);
  }

  @override
  int get typeId => aRestaurantAdapterTyepID;
}

class AvailabilityAdapter extends TypeAdapter<Availability> {
  @override
  Availability read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Availability(
      status: fields[0] as int,
      text: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Availability obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get typeId => aAvailabilityAdaptertypeID;
}
