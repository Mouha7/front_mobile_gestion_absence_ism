import 'package:front_mobile_gestion_absence_ism/app/data/enums/role.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/utilisateur.dart';

class Etudiant extends Utilisateur {
  final String matricule;
  final String filiere;
  final String niveau;
  
  Etudiant({
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    required this.matricule,
    required this.filiere,
    required this.niveau,
  }) : super(
    role: Role.ETUDIANT,
  );
  
  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      matricule: json['matricule'],
      filiere: json['filiere'],
      niveau: json['niveau'],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['matricule'] = matricule;
    data['filiere'] = filiere;
    data['niveau'] = niveau;
    return data;
  }
}