import 'package:front_mobile_gestion_absence_ism/app/data/enums/statut_absence.dart';
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
    switch (typeStr.toUpperCase()) {  // Ajout de toUpperCase() pour gérer les différentes casses
      case 'ABSENCE_COMPLETE':
        return TypeAbsence.ABSENCE_COMPLETE;
      case 'RETARD':
        return TypeAbsence.RETARD;
      case 'PRESENT':  // Ajout du cas pour PRESENT
        return TypeAbsence.PRESENT;
      default:
        print('⚠️ Type d\'absence non reconnu: "$typeStr", utilisation de RETARD par défaut');
        return TypeAbsence.RETARD;  // Valeur par défaut au lieu de lancer une exception
    }
  }
}
