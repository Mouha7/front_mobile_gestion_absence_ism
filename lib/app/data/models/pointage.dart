class Pointage {
  final String id;
  final String matiere; // ex: "Informatique"
  final String classe;  // ex: "NDIAYE", "WANE", "DIOP"
  final String date;    // "2023/07/04"
  final String heure;   // "8 heures", "4 heures"
  final String salle;   // optionnel, si tu veux l’ajouter

  Pointage({
    required this.id,
    required this.matiere,
    required this.classe,
    required this.date,
    required this.heure,
    required this.salle,
  });

  factory Pointage.fromJson(Map<String, dynamic> json) => Pointage(
        id: json['id'].toString(),
        matiere: json['matiere'] ?? '',
        classe: json['classe'] ?? '',
        date: json['date'] ?? '',
        heure: json['heure'] ?? '',
        salle: json['salle'] ?? '',
      );


  Map<String, dynamic> toJson() => {
        'id': id,
        'matiere': matiere,
        'classe': classe,
        'date': date,
        'heure': heure,
        'salle': salle,
      
      };
  }

