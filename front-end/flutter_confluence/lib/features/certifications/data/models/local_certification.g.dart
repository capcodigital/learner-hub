// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_certification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalCertificationAdapter extends TypeAdapter<LocalCertification> {
  @override
  final int typeId = 0;

  @override
  LocalCertification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalCertification()
      ..name = fields[0] as String
      ..platform = fields[1] as String
      ..certificationName = fields[2] as String
      ..date = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, LocalCertification obj) {
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
      other is LocalCertificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
