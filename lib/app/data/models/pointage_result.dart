class PointageResult {
  final String id;
  final String? etudiantNom;
  final String? coursNom;
  final String? matricule;
  final String? date;
  final String heureArrivee;
  final String? typeAbsence;
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
}
