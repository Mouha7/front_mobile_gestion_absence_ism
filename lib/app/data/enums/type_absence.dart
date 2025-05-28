enum StatutAbsence {
  NON_JUSTIFIEE,
  JUSTIFICATION_EN_ATTENTE,
  JUSTIFICATION_VALIDEE,
  JUSTIFICATION_REJETEE
}

extension StatutAbsenceExtension on StatutAbsence {
  String get displayName {
    switch (this) {
      case StatutAbsence.NON_JUSTIFIEE:
        return 'Non justifiée';
      case StatutAbsence.JUSTIFICATION_EN_ATTENTE:
        return 'Justification en attente';
      case StatutAbsence.JUSTIFICATION_VALIDEE:
        return 'Justification validée';
      case StatutAbsence.JUSTIFICATION_REJETEE:
        return 'Justification rejetée';
      }
  }
  
  bool get estJustifiable {
    return this == StatutAbsence.NON_JUSTIFIEE;
  }
}