class HistoriqueVigileResponse {
  final String id;
  final String etudiantNom;
  final String matricule;
  final String coursNom;
  final String date;
  final String heureArrivee;
  final String minutesRetard;
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