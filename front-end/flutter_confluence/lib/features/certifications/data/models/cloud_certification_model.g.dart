// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_certification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CloudCertificationModelAdapter
    extends TypeAdapter<CloudCertificationModel> {
  @override
  final int typeId = 1;

  @override
  CloudCertificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CloudCertificationModel(
      name: fields[0] as String,
      platform: fields[1] as String,
      certificationName: fields[2] as String,
      date: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CloudCertificationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.platform)
      ..writeByte(2)
      ..write(obj.certificationName)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudCertificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
