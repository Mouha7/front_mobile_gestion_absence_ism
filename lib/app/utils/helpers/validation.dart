// Fonctions de validation
/// Classe utilitaire pour la validation des entrées utilisateur
class Validation {
  /// Valide un email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre email';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez saisir un email valide';
    }
    
    return null; // Validation réussie
  }

  /// Valide un mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre mot de passe';
    }
    
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    
    return null; // Validation réussie
  }

  /// Valide un matricule d'étudiant
  static String? validateMatricule(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir le matricule';
    }
    
    // Format attendu: ISM-YYYY-XXX (YYYY=année, XXX=numéro)
    final matriculeRegex = RegExp(r'^ISM-\d{4}-\d{3}$');
    if (!matriculeRegex.hasMatch(value)) {
      return 'Format invalide (ISM-ANNEE-NUMERO)';
    }
    
    return null; // Validation réussie
  }

  /// Valide qu'un champ n'est pas vide
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Le champ $fieldName est requis';
    }
    
    return null; // Validation réussie
  }

  /// Valide la longueur minimale d'un texte
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Le champ $fieldName est requis';
    }
    
    if (value.length < minLength) {
      return 'Le champ $fieldName doit contenir au moins $minLength caractères';
    }
    
    return null; // Validation réussie
  }

  /// Valide une heure au format HH:MM
  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir une heure';
    }
    
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value)) {
      return 'Format d\'heure invalide (HH:MM)';
    }
    
    return null; // Validation réussie
  }
}