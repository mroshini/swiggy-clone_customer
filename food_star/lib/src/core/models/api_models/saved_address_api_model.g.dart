// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_address_api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AAddressAdapter extends TypeAdapter<AAddress> {
  @override
  AAddress read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AAddress(
      id: fields[0] as dynamic,
      addressType: fields[1] as dynamic,
      building: fields[2] as String,
      landmark: fields[3] as String,
      address: fields[4] as String,
      lat: fields[5] as double,
      lang: fields[6] as double,
      city: fields[7] as String,
      state: fields[8] as String,
      distance: fields[9] as dynamic,
      addressTypeText: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AAddress obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.addressType)
      ..writeByte(2)
      ..write(obj.building)
      ..writeByte(3)
      ..write(obj.landmark)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.lat)
      ..writeByte(6)
      ..write(obj.lang)
      ..writeByte(7)
      ..write(obj.city)
      ..writeByte(8)
      ..write(obj.state)
      ..writeByte(9)
      ..write(obj.distance)
      ..writeByte(10)
      ..write(obj.addressTypeText);
  }

  @override
  int get typeId => aAddressAdaptertypeID;
}
