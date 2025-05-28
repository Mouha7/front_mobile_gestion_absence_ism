import 'package:front_mobile_gestion_absence_ism/app/data/enums/role.dart';

class Utilisateur {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final Role role;
  
  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
  });
  
  String get nomComplet => '$prenom $nom';
  
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      role: _parseRole(json['role']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role.toString().split('.').last,
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