// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_action_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartActionApiModelAdapter extends TypeAdapter<CartActionApiModel> {
  @override
  CartActionApiModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartActionApiModel(
      aCart: fields[0] as CartQuantityPrice,
      foodItemView: (fields[2] as List)?.cast<ACommonFoodItem>(),
      message: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CartActionApiModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.aCart)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.foodItemView);
  }

  @override
  int get typeId => cartActionApiModelAdapterID;
}

class CartQuantityPriceAdapter extends TypeAdapter<CartQuantityPrice> {
  @override
  CartQuantityPrice read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartQuantityPrice(
      totalQuantity: fields[0] as dynamic,
      totalPrice: fields[1] as dynamic,
      foodIds: fields[2] as dynamic,
      resId: fields[3] as dynamic,
      restaurantName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CartQuantityPrice obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalQuantity)
      ..writeByte(1)
      ..write(obj.totalPrice)
      ..writeByte(2)
      ..write(obj.foodIds)
      ..writeByte(3)
      ..write(obj.resId)
      ..writeByte(4)
      ..write(obj.restaurantName);
  }

  @override
  int get typeId => cartQuantityPriceAdapterID;
}
