import 'package:get/get.dart';
import 'dart:async';

import '../data/services/storage_service.dart';

class EtudiantController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Propriétés observables
  final isServerConnected = true.obs;
  final isLoading = false.obs;
  final retards = <Map<String, dynamic>>[].obs;
  final qrCodeData = ''.obs; // Données du code QR (matricule étudiant)

  @override
  void onReady() {
    super.onReady();
    // Initialisation des données au démarrage
    refreshData();

    // Initialisation des données du QR code
    _initQRCodeData();
  }

  // Méthode pour rafraîchir les données
  Future<void> refreshData() async {
    try {
      isLoading.value = true;

      // Simulation d'un délai réseau
      await Future.delayed(const Duration(seconds: 1));

      // Vérification de la connexion au serveur (à remplacer par une vraie vérification)
      isServerConnected.value = await _checkServerConnection();

      if (isServerConnected.value) {
        // Récupération des données de retards (à remplacer par un appel API réel)
        await _fetchRetardsData();

        // Rafraîchissement des données du QR code
        await _refreshQRCode();
      }
    } catch (e) {
      // Gestion des erreurs
      isServerConnected.value = false;
      print('Erreur lors du rafraîchissement des données: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode privée pour vérifier la connexion au serveur
  Future<bool> _checkServerConnection() async {
    try {
      // Par exemple, faire une requête ping vers le serveur
      await Future.delayed(const Duration(seconds: 1));

      // Pour démonstration, on retourne true (connecté)
      return true;
    } catch (e) {
      print('Erreur de connexion au serveur: $e');
      return false;
    }
  }

  // Méthode privée pour récupérer les données de retards
  Future<void> _fetchRetardsData() async {
    try {
      final userData = _storageService.getUser();
      print('Données utilisateur récupérées: $userData');

      if (userData != null && userData['absences'] != null) {
        final absences = List<Map<String, dynamic>>.from(userData['absences']);

        // Transformer les absences en format d'affichage pour les retards
        final formattedRetards =
            absences.map((absence) {
              return {
                'nomCours':
                    absence['nomCours'] ??
                    absence['cours']?['nom'] ??
                    'Matière inconnue',
                'date': absence['heurePointage'] ?? '',
                'heurePointage': absence['heurePointage'],
                'duree': '${absence['minutesRetard'] ?? '0'} min',
                'type': absence['type'] ?? 'RETARD',
                'professeur':
                    absence['professeur'] ?? absence['cours']?['enseignant'],
                'salle': absence['salle'] ?? absence['cours']?['salle'],
                'heureDebut':
                    absence['heureDebut'] ?? absence['cours']?['heureDebut'],
              };
            }).toList();

        // Prendre les 5 derniers retards
        retards.assignAll(formattedRetards.take(5));
        return;
      }

      retards.clear();
    } catch (e) {
      print('Erreur lors de la récupération des retards: $e');
      retards.clear();
    }
  }

  // Méthode pour initialiser les données du QR code
  void _initQRCodeData() {
    try {
      final userData = _storageService.getUser();
      print('Données utilisateur récupérées: $userData');

      if (userData != null) {
        String? userMatricule = userData['matricule']?.toString();
        if (userMatricule != null && userMatricule.isNotEmpty) {
          qrCodeData.value = userMatricule;
          print('✅ QR Code initialisé avec le matricule: ${qrCodeData.value}');
          return;
        }
      }

      print('❌ Aucun matricule trouvé dans les données utilisateur');
      qrCodeData.value = 'ETUDIANT-INCONNU';
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation du QR code: $e');
      qrCodeData.value = 'ETUDIANT-ERREUR';
    }
  }

  // Méthode pour rafraîchir les données du QR code
  Future<void> _refreshQRCode() async {
    try {
      final userData = _storageService.getUser();
      print('Données utilisateur rafraîchies: $userData');

      if (userData != null) {
        String? userMatricule = userData['matricule']?.toString();
        if (userMatricule != null && userMatricule.isNotEmpty) {
          qrCodeData.value = userMatricule;
          print('✅ QR Code rafraîchi: ${qrCodeData.value}');
          return;
        }
      }

      print('❌ Aucun matricule trouvé lors du rafraîchissement');
    } catch (e) {
      print('❌ Erreur lors du rafraîchissement du QR code: $e');
    }
  }
}
