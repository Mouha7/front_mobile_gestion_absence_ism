import 'package:hive/hive.dart';

part 'pointage_result.g.dart';

@HiveType(typeId: 8)
class PointageResult {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? etudiantNom;

  @HiveField(2)
  final String? coursNom;

  @HiveField(3)
  final String? matricule;

  @HiveField(4)
  final String? date;

  @HiveField(5)
  final String heureArrivee;

  @HiveField(6)
  final String? typeAbsence;

  @HiveField(7)
  final int? minutesRetard;

  PointageResult({
    required this.id,
    this.typeAbsence,
    required this.heureArrivee,
    this.minutesRetard,
    this.coursNom,
    this.etudiantNom,
    this.matricule,
    this.date,
  });

  factory PointageResult.fromJson(Map<String, dynamic> json) {
    return PointageResult(
      id: json['id'],
      typeAbsence: json['typeAbsence'],
      heureArrivee: json['heureArrivee'],
      minutesRetard: json['minutesRetard'],
      coursNom: json['coursNom'],
      etudiantNom: json['etudiantNom'],
      matricule: json['matricule'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'typeAbsence': typeAbsence,
      'heureArrivee': heureArrivee,
      'minutesRetard': minutesRetard,
      'coursNom': coursNom,
      'etudiantNom': etudiantNom,
      'matricule': matricule,
      'date': date,
    };
  }
}
