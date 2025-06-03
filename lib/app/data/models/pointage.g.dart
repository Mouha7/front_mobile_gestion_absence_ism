// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pointage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointageAdapter extends TypeAdapter<Pointage> {
  @override
  final int typeId = 7;

  @override
  Pointage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pointage(
      id: fields[0] as String,
      matiere: fields[1] as String,
      classe: fields[2] as String,
      date: fields[3] as String,
      heure: fields[4] as String,
      salle: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Pointage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.matiere)
      ..writeByte(2)
      ..write(obj.classe)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.heure)
      ..writeByte(5)
      ..write(obj.salle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
