import 'package:hive/hive.dart';

part 'pointage.g.dart';

@HiveType(typeId: 7)
class Pointage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String matiere;

  @HiveField(2)
  final String classe;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final String heure;

  @HiveField(5)
  final String? salle;

  Pointage({
    required this.id,
    required this.matiere,
    required this.classe,
    required this.date,
    required this.heure,
    this.salle,
  });

  factory Pointage.fromJson(Map<String, dynamic> json) => Pointage(
    id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
    matiere: json['matiere'] ?? '',
    classe: json['classe'] ?? '',
    date: json['date'] ?? '',
    heure: json['heure'] ?? '',
    salle: json['salle'],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matiere': matiere,
      'classe': classe,
      'date': date,
      'heure': heure,
      'salle': salle,
    };
  }
}
