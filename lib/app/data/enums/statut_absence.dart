enum TypeAbsence {
  ABSENCE_COMPLETE,
  RETARD
}

extension TypeAbsenceExtension on TypeAbsence {
  String get displayName {
    switch (this) {
      case TypeAbsence.ABSENCE_COMPLETE:
        return 'Absence complète';
      case TypeAbsence.RETARD:
        return 'Retard';
      }
  }
}