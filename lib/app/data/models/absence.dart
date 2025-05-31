import 'package:front_mobile_gestion_absence_ism/app/data/enums/statut_absence.dart';

import 'cours.dart';

class Absence {
  final String id;
  final String heurePointage;
  final String minutesRetard;
  final TypeAbsence type;
  final Cours? cours;
  final bool isJustification;

  Absence({
    required this.id,
    required this.heurePointage,
    required this.minutesRetard,
    required this.type,
    this.cours,
    required this.isJustification,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id']?.toString() ?? '',
      heurePointage: json['heurePointage']?.toString() ?? '00:00',
      minutesRetard: json['minutesRetard']?.toString() ?? '0',
      type: _parseType(json['type']?.toString() ?? 'RETARD'),
      cours: json['cours'] != null ? Cours.fromJson(json['cours']) : null,
      isJustification: json['justification'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heurePointage': heurePointage,
      'minutesRetard': minutesRetard,
      'type': type.toString().split('.').last,
      'coursId': cours?.id,
      'isJustification': isJustification,
    };
  }

  static TypeAbsence _parseType(String typeStr) {
    switch (typeStr) {
      case 'ABSENCE_COMPLETE':
        return TypeAbsence.ABSENCE_COMPLETE;
      case 'RETARD':
        return TypeAbsence.RETARD;
      default:
        throw Exception('Type d\'absence inconnu: $typeStr');
    }
  }
}
