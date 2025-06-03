// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'justification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JustificationAdapter extends TypeAdapter<Justification> {
  @override
  final int typeId = 6;

  @override
  Justification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Justification(
      id: fields[0] as String,
      dateCreation: fields[1] as String,
      description: fields[2] as String,
      documentPath: fields[3] as String?,
      statut: fields[4] as StatutJustification,
      absenceId: fields[5] as String,
      adminId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Justification obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateCreation)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.documentPath)
      ..writeByte(4)
      ..write(obj.statut)
      ..writeByte(5)
      ..write(obj.absenceId)
      ..writeByte(6)
      ..write(obj.adminId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JustificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatutJustificationAdapter extends TypeAdapter<StatutJustification> {
  @override
  final int typeId = 5;

  @override
  StatutJustification read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StatutJustification.EN_ATTENTE;
      case 1:
        return StatutJustification.VALIDEE;
      case 2:
        return StatutJustification.REJETEE;
      default:
        return StatutJustification.EN_ATTENTE;
    }
  }

  @override
  void write(BinaryWriter writer, StatutJustification obj) {
    switch (obj) {
      case StatutJustification.EN_ATTENTE:
        writer.writeByte(0);
        break;
      case StatutJustification.VALIDEE:
        writer.writeByte(1);
        break;
      case StatutJustification.REJETEE:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatutJustificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
