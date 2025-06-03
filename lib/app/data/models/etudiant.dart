import 'package:front_mobile_gestion_absence_ism/app/data/enums/role.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/utilisateur.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/absence.dart';
import 'package:hive/hive.dart';

part 'etudiant.g.dart';

@HiveType(typeId: 1)
class Etudiant extends Utilisateur {
  @HiveField(6)
  final String matricule;

  @HiveField(7)
  final String filiere;

  @HiveField(8)
  final String niveau;

  @HiveField(9)
  final String classe;

  @override
  @HiveField(10)
  final List<Absence> absences;

  Etudiant({
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    required this.matricule,
    required this.filiere,
    required this.niveau,
    required this.classe,
    this.absences = const [],
  }) : super(role: Role.ETUDIANT);

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    List<Absence> absencesList = [];
    if (json['absences'] != null) {
      absencesList =
          (json['absences'] as List)
              .map((item) => Absence.fromJson(item))
              .toList();
    }

    return Etudiant(
      id: json['id']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      matricule: json['matricule']?.toString() ?? '',
      filiere: json['filiere']?.toString() ?? '',
      niveau: json['niveau']?.toString() ?? '',
      classe: json['classe']?.toString() ?? '',
      absences: absencesList,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['matricule'] = matricule;
    data['filiere'] = filiere;
    data['email'] = email;
    data['classe'] = classe;
    data['niveau'] = niveau;
    data['absences'] = absences.map((e) => e.toJson()).toList();
    return data;
  }
}
