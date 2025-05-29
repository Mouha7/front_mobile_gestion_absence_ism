// Constantes de l'application

/// Constantes pour les messages d'erreur et de succès
class AppMessages {
  // Messages d'erreur
  static const String errorLogin = 'Échec de connexion. Vérifiez vos identifiants.';
  static const String errorNetwork = 'Problème de connexion au serveur. Vérifiez votre connexion internet.';
  static const String errorGeneric = 'Une erreur s\'est produite. Veuillez réessayer.';
  static const String errorNoData = 'Aucune donnée disponible.';
  
  // Messages de succès
  static const String successLogin = 'Connexion réussie !';
  static const String successJustification = 'Justification soumise avec succès.';
  static const String successPresence = 'Présence enregistrée avec succès.';
  static const String successAbsence = 'Absence enregistrée avec succès.';
  
  // Messages d'information
  static const String infoLoadingData = 'Chargement des données...';
  static const String infoScanQR = 'Scannez le QR code de l\'étudiant';
}

/// Constantes pour les préférences de stockage
class StorageKeys {
  static const String authToken = 'auth_token';
  static const String userData = 'user_data';
  static const String lastSync = 'last_sync';
  static const String rememberMe = 'remember_me';
  static const String darkMode = 'dark_mode';
}

/// Constantes pour les tailles et dimensions
class AppSizes {
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;
  
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
}

/// Constantes pour les assets de l'application
class AppAssets {
  static const String logoPath = 'assets/images/logo_ism.png';
  static const String backgroundPath = 'assets/images/background.jpg';
  static const String placeholderUser = 'assets/images/placeholder_user.png';
}