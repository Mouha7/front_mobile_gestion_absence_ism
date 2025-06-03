// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbsenceAdapter extends TypeAdapter<Absence> {
  @override
  final int typeId = 3;

  @override
  Absence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Absence(
      id: fields[0] as String,
      heurePointage: fields[1] as String,
      minutesRetard: fields[2] as String,
      type: fields[3] as TypeAbsence,
      nomCours: fields[4] as String,
      isJustification: fields[5] as bool,
      professeur: fields[6] as String,
      salle: fields[7] as String,
      heureDebut: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Absence obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.heurePointage)
      ..writeByte(2)
      ..write(obj.minutesRetard)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.nomCours)
      ..writeByte(5)
      ..write(obj.isJustification)
      ..writeByte(6)
      ..write(obj.professeur)
      ..writeByte(7)
      ..write(obj.salle)
      ..writeByte(8)
      ..write(obj.heureDebut);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbsenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
