// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateur.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UtilisateurAdapter extends TypeAdapter<Utilisateur> {
  @override
  final int typeId = 0;

  @override
  Utilisateur read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Utilisateur(
      id: fields[0] as String,
      nom: fields[1] as String,
      prenom: fields[2] as String,
      email: fields[3] as String,
      role: fields[4] as Role,
      absences: (fields[5] as List).cast<Absence>(),
    );
  }

  @override
  void write(BinaryWriter writer, Utilisateur obj) {
    writer
      ..writeByte(6)
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
      other is UtilisateurAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
