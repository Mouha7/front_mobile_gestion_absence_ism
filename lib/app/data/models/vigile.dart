import 'package:front_mobile_gestion_absence_ism/app/data/enums/role.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/utilisateur.dart';

class Vigile extends Utilisateur {
  final String badge;
  
  Vigile({
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    required this.badge,
  }) : super(
    role: Role.VIGILE,
  );
  
  factory Vigile.fromJson(Map<String, dynamic> json) {
    return Vigile(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      badge: json['badge'],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['badge'] = badge;
    return data;
  }
}