import 'package:front_mobile_gestion_absence_ism/app/data/enums/statut_absence.dart';

class Absence {
  final String id;
  final String heurePointage;
  final String minutesRetard;
  final TypeAbsence type;
  final String nomCours;
  final String professeur;
  final String salle;
  final String heureDebut;
  final bool isJustification;

  Absence({
    required this.id,
    required this.heurePointage,
    required this.minutesRetard,
    required this.type,
    required this.nomCours,
    required this.isJustification,
    required this.professeur,
    required this.salle,
    required this.heureDebut,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id']?.toString() ?? '',
      heurePointage: json['heurePointage']?.toString() ?? '00:00',
      minutesRetard: json['minutesRetard']?.toString() ?? '0',
      type: _parseType(json['type']?.toString() ?? 'RETARD'),
      nomCours: json['nomCours']?.toString() ?? "cours",
      isJustification: json['justification'] ?? false,
      professeur: json['professeur'] ?? 'professeur',
      salle: json['salle'] ?? 'salle',
      heureDebut: json['heureDebut'] ?? '00:00'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heurePointage': heurePointage,
      'minutesRetard': minutesRetard,
      'type': type.toString().split('.').last,
      'isJustification': isJustification,
      'nomCours': nomCours,
      'professeur': professeur,
      'salle': salle,
      'heureDebut': heureDebut
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
