// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cours.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoursAdapter extends TypeAdapter<Cours> {
  @override
  final int typeId = 4;

  @override
  Cours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cours(
      id: fields[0] as String,
      nom: fields[1] as String,
      enseignant: fields[2] as String,
      salle: fields[3] as String,
      heureDebut: fields[4] as String,
      heureFin: fields[5] as String,
      jour: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Cours obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.enseignant)
      ..writeByte(3)
      ..write(obj.salle)
      ..writeByte(4)
      ..write(obj.heureDebut)
      ..writeByte(5)
      ..write(obj.heureFin)
      ..writeByte(6)
      ..write(obj.jour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
