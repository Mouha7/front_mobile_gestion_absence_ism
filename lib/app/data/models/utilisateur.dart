import 'package:front_mobile_gestion_absence_ism/app/data/enums/role.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/absence.dart';

class Utilisateur {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final Role role;
  List<Absence> absences;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.absences = const [],
  });

  String get nomComplet => '$prenom $nom';

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    List<Absence> absences = [];
    if (json['absences'] != null) {
      absences =
          (json['absences'] as List)
              .map((item) => Absence.fromJson(item))
              .toList();
    }

    return Utilisateur(
      id: json['id']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: _parseRole(json['role']?.toString() ?? 'ETUDIANT'),
      absences: absences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role.toString().split('.').last,
      'absences': absences.map((e) => e.toJson()).toList(),
    };
  }

  static Role _parseRole(String roleStr) {
    switch (roleStr) {
      case 'ETUDIANT':
        return Role.ETUDIANT;
      case 'ADMIN':
        return Role.ADMIN;
      case 'VIGILE':
        return Role.VIGILE;
      default:
        throw Exception('Role inconnu: $roleStr');
    }
  }
}
