// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_bill_detail_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartBillDetailsApiModelAdapter
    extends TypeAdapter<CartBillDetailsApiModel> {
  @override
  CartBillDetailsApiModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartBillDetailsApiModel(
      aCartItems: (fields[0] as List)?.cast<ACommonFoodItem>(),
      addressId: fields[1] as int,
      address: fields[2] as String,
      distance: fields[3] as String,
      durationText: fields[4] as String,
      itemPrice: fields[5] as int,
      promoamount: fields[6] as int,
      deliveryCharge: fields[7] as dynamic,
      savedPrice: fields[8] as dynamic,
      grandTotal: fields[9] as dynamic,
      restaurant: fields[10] as CartRestaurantData,
      phoneNumber: fields[11] as int,
      message: fields[12] as String,
      aCart: fields[13] as CartQuantityPrice,
    );
  }

  @override
  void write(BinaryWriter writer, CartBillDetailsApiModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.aCartItems)
      ..writeByte(1)
      ..write(obj.addressId)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.distance)
      ..writeByte(4)
      ..write(obj.durationText)
      ..writeByte(5)
      ..write(obj.itemPrice)
      ..writeByte(6)
      ..write(obj.promoamount)
      ..writeByte(7)
      ..write(obj.deliveryCharge)
      ..writeByte(8)
      ..write(obj.savedPrice)
      ..writeByte(9)
      ..write(obj.grandTotal)
      ..writeByte(10)
      ..write(obj.restaurant)
      ..writeByte(11)
      ..write(obj.phoneNumber)
      ..writeByte(12)
      ..write(obj.message)
      ..writeByte(13)
      ..write(obj.aCart);
  }

  @override
  int get typeId => cartBillDetailsApiModelAdapterID;
}

class CartRestaurantDataAdapter extends TypeAdapter<CartRestaurantData> {
  @override
  CartRestaurantData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartRestaurantData(
      id: fields[0] as int,
      name: fields[1] as String,
      logo: fields[2] as String,
      location: fields[3] as String,
      deliveryTime: fields[4] as int,
      mode: fields[5] as String,
      src: fields[6] as String,
      availability: fields[7] as Availability,
    );
  }

  @override
  void write(BinaryWriter writer, CartRestaurantData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.logo)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.deliveryTime)
      ..writeByte(5)
      ..write(obj.mode)
      ..writeByte(6)
      ..write(obj.src)
      ..writeByte(7)
      ..write(obj.availability);
  }

  @override
  int get typeId => cartRestaurantDataAdapterId;
}
