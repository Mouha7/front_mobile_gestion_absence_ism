// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pointage_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointageResultAdapter extends TypeAdapter<PointageResult> {
  @override
  final int typeId = 8;

  @override
  PointageResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PointageResult(
      id: fields[0] as String,
      typeAbsence: fields[6] as String?,
      heureArrivee: fields[5] as String,
      minutesRetard: fields[7] as int?,
      coursNom: fields[2] as String?,
      etudiantNom: fields[1] as String?,
      matricule: fields[3] as String?,
      date: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PointageResult obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.etudiantNom)
      ..writeByte(2)
      ..write(obj.coursNom)
      ..writeByte(3)
      ..write(obj.matricule)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.heureArrivee)
      ..writeByte(6)
      ..write(obj.typeAbsence)
      ..writeByte(7)
      ..write(obj.minutesRetard);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointageResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
