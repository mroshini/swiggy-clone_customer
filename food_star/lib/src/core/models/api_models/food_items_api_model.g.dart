// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_items_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommonCatFoodItemAdapter extends TypeAdapter<CommonCatFoodItem> {
  @override
  CommonCatFoodItem read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommonCatFoodItem(
      mainCat: fields[0] as int,
      foodcount: fields[1] as int,
      continution: fields[2] as int,
      aFoodItems: (fields[6] as List)?.cast<ACommonFoodItem>(),
      mainCatName: fields[7] as String,
      id: fields[3] as int,
      restaurantId: fields[4] as int,
      restaurantDetail: fields[5] as RestaurantDetail,
    );
  }

  @override
  void write(BinaryWriter writer, CommonCatFoodItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.mainCat)
      ..writeByte(1)
      ..write(obj.foodcount)
      ..writeByte(2)
      ..write(obj.continution)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.restaurantId)
      ..writeByte(5)
      ..write(obj.restaurantDetail)
      ..writeByte(6)
      ..write(obj.aFoodItems)
      ..writeByte(7)
      ..write(obj.mainCatName);
  }

  @override
  int get typeId => commonCatFoodItemAdaptertypeID;
}

class ACommonFoodItemAdapter extends TypeAdapter<ACommonFoodItem> {
  @override
  ACommonFoodItem read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ACommonFoodItem(
      id: fields[0] as int,
      restaurantId: fields[1] as int,
      foodItem: fields[2] as String,
      description: fields[3] as String,
      price: fields[4] as int,
      sellingPrice: fields[5] as int,
      originalPrice: fields[6] as int,
      status: fields[7] as String,
      availableFrom: fields[8] as String,
      availableTo: fields[9] as String,
      availableFrom2: fields[10] as String,
      availableTo2: fields[11] as String,
      itemStatus: fields[12] as String,
      image: fields[13] as String,
      cartDetail: fields[14] as CartDetail,
      exactSrc: fields[15] as String,
      availability: fields[16] as Availability,
      showPrice: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ACommonFoodItem obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.restaurantId)
      ..writeByte(2)
      ..write(obj.foodItem)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.sellingPrice)
      ..writeByte(6)
      ..write(obj.originalPrice)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.availableFrom)
      ..writeByte(9)
      ..write(obj.availableTo)
      ..writeByte(10)
      ..write(obj.availableFrom2)
      ..writeByte(11)
      ..write(obj.availableTo2)
      ..writeByte(12)
      ..write(obj.itemStatus)
      ..writeByte(13)
      ..write(obj.image)
      ..writeByte(14)
      ..write(obj.cartDetail)
      ..writeByte(15)
      ..write(obj.exactSrc)
      ..writeByte(16)
      ..write(obj.availability)
      ..writeByte(17)
      ..write(obj.showPrice);
  }

  @override
  int get typeId => aCommonFoodItemAdaptertypeID;
}

class CartDetailAdapter extends TypeAdapter<CartDetail> {
  @override
  CartDetail read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartDetail(
      quantity: fields[0] as int,
      itemNote: fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, CartDetail obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.itemNote);
  }

  @override
  int get typeId => cartDetailAdaptertypeID;
}
