import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'justification.g.dart';

@HiveType(typeId: 5)
enum StatutJustification {
  @HiveField(0)
  EN_ATTENTE,

  @HiveField(1)
  VALIDEE,

  @HiveField(2)
  REJETEE
}

@HiveType(typeId: 6)
class Justification {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String dateCreation;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? documentPath;

  @HiveField(4)
  final StatutJustification statut;

  @HiveField(5)
  final String absenceId;

  @HiveField(6)
  final String? adminId;

  Justification({
    required this.id,
    required this.dateCreation,
    required this.description,
    this.documentPath,
    required this.statut,
    required this.absenceId,
    this.adminId,
  });

  String get dateCreationFormatee {
    final DateTime dateObj = DateTime.parse(dateCreation);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateObj);
  }

  factory Justification.fromJson(Map<String, dynamic> json) {
    return Justification(
      id: json['id'],
      dateCreation: json['dateCreation'],
      description: json['description'],
      documentPath: json['documentPath'],
      statut: _parseStatut(json['statut']),
      absenceId: json['absenceId'],
      adminId: json['adminId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateCreation': dateCreation,
      'description': description,
      'documentPath': documentPath,
      'statut': statut.toString().split('.').last,
      'absenceId': absenceId,
      'adminId': adminId,
    };
  }

  static StatutJustification _parseStatut(String statutStr) {
    switch (statutStr) {
      case 'EN_ATTENTE':
        return StatutJustification.EN_ATTENTE;
      case 'VALIDEE':
        return StatutJustification.VALIDEE;
      case 'REJETEE':
        return StatutJustification.REJETEE;
      default:
        throw Exception('Statut de justification inconnu: $statutStr');
    }
  }
}
