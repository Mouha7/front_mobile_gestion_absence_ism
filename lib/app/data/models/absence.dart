import 'package:front_mobile_gestion_absence_ism/app/data/enums/statut_absence.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/enums/statut_justification.dart';
import 'package:hive/hive.dart';

part 'absence.g.dart';

@HiveType(typeId: 3)
class Absence {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String heurePointage;

  @HiveField(2)
  final String minutesRetard;

  @HiveField(3)
  final TypeAbsence type;

  @HiveField(4)
  final String nomCours;

  @HiveField(5)
  final bool isJustification;

  @HiveField(6)
  final String professeur;

  @HiveField(7)
  final String salle;

  @HiveField(8)
  final String heureDebut;

  @HiveField(9)
  final String? justificationId;

  @HiveField(10)
  final String? descriptionJustification;

  @HiveField(11)
  final List<String>? piecesJointes;

  @HiveField(12)
  final StatutJustification? statutJustification;

  @HiveField(13)
  final String? dateValidationJustification;

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
    this.justificationId,
    this.descriptionJustification,
    this.piecesJointes,
    this.statutJustification,
    this.dateValidationJustification,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    List<String>? piecesList;
    if (json['piecesJointes'] != null) {
      piecesList = List<String>.from(json['piecesJointes']);
    }

    return Absence(
      id: json['id']?.toString() ?? '',
      heurePointage: json['heurePointage']?.toString() ?? '00:00',
      minutesRetard: json['minutesRetard']?.toString() ?? '0',
      type: _parseType(json['type']?.toString() ?? 'RETARD'),
      nomCours: json['nomCours']?.toString() ?? "cours",
      isJustification: json['justification'] ?? false,
      professeur: json['professeur'] ?? 'professeur',
      salle: json['salle'] ?? 'salle',
      heureDebut: json['heureDebut'] ?? '00:00',
      justificationId: json['justificationId']?.toString(),
      descriptionJustification: json['descriptionJustification'],
      piecesJointes: piecesList,
      statutJustification:
          json['statutJustification'] != null
              ? _parseStatutJustification(json['statutJustification'])
              : null,
      dateValidationJustification: json['dateValidationJustification'],
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
      'heureDebut': heureDebut,
      'justificationId': justificationId,
      'descriptionJustification': descriptionJustification,
      'piecesJointes': piecesJointes,
      'statutJustification': statutJustification?.toString().split('.').last,
      'dateValidationJustification': dateValidationJustification,
    };
  }

  static TypeAbsence _parseType(String typeStr) {
    switch (typeStr.toUpperCase()) {
      case 'ABSENCE_COMPLETE':
        return TypeAbsence.ABSENCE_COMPLETE;
      case 'RETARD':
        return TypeAbsence.RETARD;
      case 'PRESENT':
        return TypeAbsence.PRESENT;
      default:
        print(
          '⚠️ Type d\'absence non reconnu: "$typeStr", utilisation de RETARD par défaut',
        );
        return TypeAbsence.RETARD;
    }
  }

  static StatutJustification _parseStatutJustification(String statutStr) {
    switch (statutStr.toUpperCase()) {
      case 'EN_ATTENTE':
        return StatutJustification.EN_ATTENTE;
      case 'VALIDEE':
        return StatutJustification.VALIDEE;
      case 'REJETEE':
        return StatutJustification.REJETEE;
      default:
        print(
          '⚠️ Statut de justification non reconnu: "$statutStr", utilisation de EN_ATTENTE par défaut',
        );
        return StatutJustification.EN_ATTENTE;
    }
  }
}
