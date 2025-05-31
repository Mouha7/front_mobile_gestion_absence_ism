class Pointage {
  final String id;
  final String matiere;
  final String classe;
  final String date;
  final String heure;
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
}
