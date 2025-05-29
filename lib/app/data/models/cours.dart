class Cours {
  final String id;
  final String nom;
  final String enseignant;
  final String salle;
  final String heureDebut;
  final String heureFin;
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