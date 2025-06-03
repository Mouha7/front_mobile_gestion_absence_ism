import 'package:hive/hive.dart';

part 'cours.g.dart';

@HiveType(typeId: 4)
class Cours {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String nom;
  
  @HiveField(2)
  final String enseignant;
  
  @HiveField(3)
  final String salle;
  
  @HiveField(4)
  final String heureDebut;
  
  @HiveField(5)
  final String heureFin;
  
  @HiveField(6)
  final String jour;
  
  Cours({
    required this.id,
    required this.nom,
    required this.enseignant,
    required this.salle,
    required this.heureDebut,
    required this.heureFin,
    required this.jour,
  });
  
  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      id: json['id'],
      nom: json['nom'],
      enseignant: json['enseignant'],
      salle: json['salle'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      jour: json['jour'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'enseignant': enseignant,
      'salle': salle,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'jour': jour,
    };
  }
  
  String get horaire => '$heureDebut - $heureFin';
}