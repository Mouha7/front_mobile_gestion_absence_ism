// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historique_vigile_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoriqueVigileResponseAdapter
    extends TypeAdapter<HistoriqueVigileResponse> {
  @override
  final int typeId = 9;

  @override
  HistoriqueVigileResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoriqueVigileResponse(
      id: fields[0] as String,
      etudiantNom: fields[1] as String,
      matricule: fields[2] as String,
      coursNom: fields[3] as String,
      date: fields[4] as String,
      heureArrivee: fields[5] as String,
      minutesRetard: fields[6] as String,
      typeAbsence: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoriqueVigileResponse obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.etudiantNom)
      ..writeByte(2)
      ..write(obj.matricule)
      ..writeByte(3)
      ..write(obj.coursNom)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.heureArrivee)
      ..writeByte(6)
      ..write(obj.minutesRetard)
      ..writeByte(7)
      ..write(obj.typeAbsence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoriqueVigileResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
