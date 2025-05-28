import 'package:front_mobile_gestion_absence_ism/app/data/enums/statut_justification.dart';
import 'package:intl/intl.dart';

class Justification {
  final String id;
  final String dateCreation;
  final String description;
  final String documentPath;
  final StatutJustification statut;
  final String? absenceId;
  final String? adminId;
  
  Justification({
    required this.id,
    required this.dateCreation,
    required this.description,
    required this.documentPath,
    required this.statut,
    this.absenceId,
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