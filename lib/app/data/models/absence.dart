import 'package:front_mobile_gestion_absence_ism/app/data/enums/statut_absence.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/enums/type_absence.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/etudiant.dart';
import 'package:intl/intl.dart';

import 'cours.dart';
import 'justification.dart';
import 'vigile.dart';

class Absence {
  final String id;
  final String date; // Format ISO: YYYY-MM-DD
  final String heureDebut;
  final String heureFin;
  final String duree;
  final TypeAbsence type;
  final StatutAbsence statut;
  
  final Etudiant? etudiant; // Peut être null dans certains contextes d'API
  final Cours? cours;
  final Justification? justification;
  final Vigile? vigile;
  
  Absence({
    required this.id,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.duree,
    required this.type,
    required this.statut,
    this.etudiant,
    this.cours,
    this.justification,
    this.vigile,
  });
  
  bool get estJustifiable => statut == StatutAbsence.NON_JUSTIFIEE;
  bool get aJustification => justification != null;
  
  String get dateFormatee {
    final DateTime dateObj = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateObj);
  }
  
  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      date: json['date'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      duree: json['duree'] ?? _calculerDuree(json['heureDebut'], json['heureFin']),
      type: _parseType(json['type']),
      statut: _parseStatut(json['statut']),
      etudiant: json['etudiant'] != null ? Etudiant.fromJson(json['etudiant']) : null,
      cours: json['cours'] != null ? Cours.fromJson(json['cours']) : null,
      justification: json['justification'] != null ? Justification.fromJson(json['justification']) : null,
      vigile: json['vigile'] != null ? Vigile.fromJson(json['vigile']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'duree': duree,
      'type': type.toString().split('.').last,
      'statut': statut.toString().split('.').last,
      'etudiantId': etudiant?.id,
      'coursId': cours?.id,
      'justificationId': justification?.id,
      'vigileId': vigile?.id,
    };
  }
  
  static TypeAbsence _parseType(String typeStr) {
    switch (typeStr) {
      case 'ABSENCE_COMPLETE':
        return TypeAbsence.ABSENCE_COMPLETE;
      case 'RETARD':
        return TypeAbsence.RETARD;
      default:
        throw Exception('Type d\'absence inconnu: $typeStr');
    }
  }
  
  static StatutAbsence _parseStatut(String statutStr) {
    switch (statutStr) {
      case 'NON_JUSTIFIEE':
        return StatutAbsence.NON_JUSTIFIEE;
      case 'JUSTIFICATION_EN_ATTENTE':
        return StatutAbsence.JUSTIFICATION_EN_ATTENTE;
      case 'JUSTIFICATION_VALIDEE':
        return StatutAbsence.JUSTIFICATION_VALIDEE;
      case 'JUSTIFICATION_REJETEE':
        return StatutAbsence.JUSTIFICATION_REJETEE;
      default:
        throw Exception('Statut d\'absence inconnu: $statutStr');
    }
  }
  
  static String _calculerDuree(String debut, String fin) {
    // Convertir heureDebut et heureFin en minutes
    List<String> debutParts = debut.split(':');
    List<String> finParts = fin.split(':');
    
    int debutMinutes = int.parse(debutParts[0]) * 60 + int.parse(debutParts[1]);
    int finMinutes = int.parse(finParts[0]) * 60 + int.parse(finParts[1]);
    
    int differenceMinutes = finMinutes - debutMinutes;
    
    // Format de la durée en H:MM
    int heures = differenceMinutes ~/ 60;
    int minutes = differenceMinutes % 60;
    
    return '${heures.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}