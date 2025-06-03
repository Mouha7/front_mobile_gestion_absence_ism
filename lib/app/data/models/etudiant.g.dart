// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etudiant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EtudiantAdapter extends TypeAdapter<Etudiant> {
  @override
  final int typeId = 1;

  @override
  Etudiant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Etudiant(
      id: fields[0] as String,
      nom: fields[1] as String,
      prenom: fields[2] as String,
      email: fields[3] as String,
      matricule: fields[6] as String,
      filiere: fields[7] as String,
      niveau: fields[8] as String,
      classe: fields[9] as String,
      absences: (fields[5] as List).cast<Absence>(),
    );
  }

  @override
  void write(BinaryWriter writer, Etudiant obj) {
    writer
      ..writeByte(10)
      ..writeByte(6)
      ..write(obj.matricule)
      ..writeByte(7)
      ..write(obj.filiere)
      ..writeByte(8)
      ..write(obj.niveau)
      ..writeByte(9)
      ..write(obj.classe)
      ..writeByte(10)
      ..write(obj.absences)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.prenom)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EtudiantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
