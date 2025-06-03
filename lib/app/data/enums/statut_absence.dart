enum TypeAbsence {
  ABSENCE_COMPLETE,
  RETARD,
  PRESENT, // Ajout de cette valeur
}

extension TypeAbsenceExtension on TypeAbsence {
  String get displayName {
    switch (this) {
      case TypeAbsence.ABSENCE_COMPLETE:
        return 'Absence';
      case TypeAbsence.RETARD:
        return 'Retard';
      case TypeAbsence.PRESENT: // Ajout de ce cas
        return 'Présent';
    }
  }

  static TypeAbsence fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'ABSENCE_COMPLETE':
        return TypeAbsence.ABSENCE_COMPLETE;
      case 'RETARD':
        return TypeAbsence.RETARD;
      case 'PRESENT': // Ajout de ce cas
        return TypeAbsence.PRESENT;
      default:
        throw Exception('Type d\'absence inconnu: $value');
    }
  }
}