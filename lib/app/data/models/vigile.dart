import 'package:front_mobile_gestion_absence_ism/app/data/enums/role.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/utilisateur.dart';

class Vigile extends Utilisateur {
  final String badge;
  final String realId;

  Vigile({
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    required this.badge,
    required this.realId,
  }) : super(role: Role.VIGILE);

  factory Vigile.fromJson(Map<String, dynamic> json) {
    return Vigile(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      badge: json['badge'],
      realId: json['realId'] ?? json['id'], // Utiliser 'id' si 'realId' n'est pas présent
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['badge'] = badge;
    data['realId'] = realId; // Inclure 'realId' dans la sérialisation
    return data;
  }
}
