// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vigile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VigileAdapter extends TypeAdapter<Vigile> {
  @override
  final int typeId = 2;

  @override
  Vigile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vigile(
      id: fields[0] as String,
      nom: fields[1] as String,
      prenom: fields[2] as String,
      email: fields[3] as String,
      badge: fields[6] as String,
      realId: fields[7] as String,
    )..absences = (fields[5] as List).cast<Absence>();
  }

  @override
  void write(BinaryWriter writer, Vigile obj) {
    writer
      ..writeByte(8)
      ..writeByte(6)
      ..write(obj.badge)
      ..writeByte(7)
      ..write(obj.realId)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.prenom)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.absences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VigileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
