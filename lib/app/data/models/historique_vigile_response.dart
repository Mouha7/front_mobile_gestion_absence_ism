import 'package:hive/hive.dart';

part 'historique_vigile_response.g.dart';

@HiveType(typeId: 9)
class HistoriqueVigileResponse {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String etudiantNom;
  
  @HiveField(2)
  final String matricule;
  
  @HiveField(3)
  final String coursNom;
  
  @HiveField(4)
  final String date;
  
  @HiveField(5)
  final String heureArrivee;
  
  @HiveField(6)
  final String minutesRetard;
  
  @HiveField(7)
  final String typeAbsence;

  HistoriqueVigileResponse({
    required this.id,
    required this.etudiantNom,
    required this.matricule,
    required this.coursNom,
    required this.date,
    required this.heureArrivee,
    required this.minutesRetard,
    required this.typeAbsence,
  });

  factory HistoriqueVigileResponse.fromJson(Map<String, dynamic> json) {
    return HistoriqueVigileResponse(
      id: json['id'] as String,
      etudiantNom: json['etudiantNom'] as String,
      matricule: json['matricule'] as String,
      coursNom: json['coursNom'] as String,
      date: json['date'] as String,
      heureArrivee: json['heureArrivee'] as String,
      minutesRetard: json['minutesRetard'] as String,
      typeAbsence: json['typeAbsence'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'etudiantNom': etudiantNom,
      'matricule': matricule,
      'coursNom': coursNom,
      'date': date,
      'heureArrivee': heureArrivee,
      'minutesRetard': minutesRetard,
      'typeAbsence': typeAbsence,
    };
  }
}