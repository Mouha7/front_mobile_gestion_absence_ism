enum StatutJustification {
  EN_ATTENTE,
  VALIDEE,
  REJETEE
}

extension StatutJustificationExtension on StatutJustification {
  String get displayName {
    switch (this) {
      case StatutJustification.EN_ATTENTE:
        return 'En attente';
      case StatutJustification.VALIDEE:
        return 'Validée';
      case StatutJustification.REJETEE:
        return 'Rejetée';
      }
  }
}