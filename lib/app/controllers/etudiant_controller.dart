import 'package:get/get.dart';
import 'dart:async';

import '../data/services/storage_service.dart';

class EtudiantController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Propriétés observables
  final isServerConnected = true.obs;
  final isLoading = false.obs;
  final retards = <Map<String, dynamic>>[].obs;
  final absences = <Map<String, dynamic>>[].obs;
  final filteredAbsences =
      <Map<String, dynamic>>[].obs; // Pour stocker les résultats filtrés
  final qrCodeData = ''.obs;

  // Propriétés pour la recherche et le filtrage
  final searchQuery = "".obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final isDateFilterActive = false.obs;

  // Propriété pour l'onglet sélectionné
  // (0 pour Accueil, 1 pour Historique)
  final selectedTabIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    // Initialisation des données au démarrage
    refreshData();

    // Initialisation des données du QR code
    _initQRCodeData();
  }

  // Méthode pour rechercher dans les absences
  void searchAbsences(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  // Méthode pour filtrer par date
  Future<void> filterByDate(DateTime date) async {
    selectedDate.value = date;
    isDateFilterActive.value = true;
    _applyFilters();
  }

  // Méthode pour réinitialiser le filtre de date
  void resetDateFilter() {
    selectedDate.value = null;
    isDateFilterActive.value = false;
    _applyFilters();
  }

  // Méthode privée pour appliquer les filtres
  void _applyFilters() {
    // Commencer avec la liste complète
    List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(
      absences,
    );

    // Appliquer le filtre de recherche si présent
    if (searchQuery.isNotEmpty) {
      result =
          result.where((absence) {
            // Rechercher dans plusieurs champs
            return (absence['nomCours']?.toString().toLowerCase() ?? '')
                    .contains(searchQuery.value.toLowerCase()) ||
                (absence['professeur']?.toString().toLowerCase() ?? '')
                    .contains(searchQuery.value.toLowerCase()) ||
                (absence['salle']?.toString().toLowerCase() ?? '').contains(
                  searchQuery.value.toLowerCase(),
                );
          }).toList();
    }

    // Appliquer le filtre de date si actif
    if (isDateFilterActive.value && selectedDate.value != null) {
      result =
          result.where((absence) {
            // Extraire la date de l'absence
            String absenceDate = absence['date'] ?? '';
            if (absenceDate.isEmpty) return false;

            try {
              // Format supposé: "2025-06-02T22:41:21.949"
              DateTime dateTime = DateTime.parse(absenceDate);
              return dateTime.year == selectedDate.value!.year &&
                  dateTime.month == selectedDate.value!.month &&
                  dateTime.day == selectedDate.value!.day;
            } catch (e) {
              print('Erreur lors du parsing de la date: $e');
              return false;
            }
          }).toList();
    }

    // Mettre à jour la liste filtrée
    filteredAbsences.assignAll(result);
  }

  // Méthode pour rafraîchir les données
  Future<void> refreshData() async {
    try {
      isLoading.value = true;

      // Simulation d'un délai réseau
      await Future.delayed(const Duration(seconds: 1));

      // Vérification de la connexion au serveur
      isServerConnected.value = await _checkServerConnection();

      if (isServerConnected.value) {
        // Une seule fonction pour récupérer toutes les données d'absence
        await _fetchAbsenceData();

        // Rafraîchissement des données du QR code
        await _refreshQRCode();
        _applyFilters(); // Appliquer les filtres après avoir récupéré les données
      }
    } catch (e) {
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

  // Méthode unique pour récupérer à la fois les absences et les retards
  Future<void> _fetchAbsenceData() async {
    try {
      final userData = _storageService.getUser();
      print('Données utilisateur récupérées: $userData');

      if (userData != null && userData['absences'] != null) {
        final allAbsences = List<Map<String, dynamic>>.from(
          userData['absences'],
        );

        // Filtrer pour exclure les présences
        final filteredAbsences =
            allAbsences.where((absence) => absence['type'] != 'PRESENT').map((
              absence,
            ) {
              return {
                'id': absence['id'],
                'nomCours':
                    absence['nomCours'] ??
                    absence['cours']?['nom'] ??
                    'Matière inconnue',
                'date': absence['heurePointage'] ?? '',
                'heurePointage': absence['heurePointage'],
                'duree':
                    absence['type'] == 'RETARD'
                        ? '${absence['minutesRetard'] ?? '0'} min'
                        : 'Journée entière',
                'type': absence['type'] ?? 'ABSENCE_COMPLETE',
                'professeur':
                    absence['professeur'] ??
                    absence['cours']?['enseignant'] ??
                    'Non spécifié',
                'salle':
                    absence['salle'] ??
                    absence['cours']?['salle'] ??
                    'Non spécifiée',
                'heureDebut':
                    absence['heureDebut'] ??
                    absence['cours']?['heureDebut'] ??
                    '',
                'justification': absence['isJustification'] ?? false,
                'justificationId': absence['justificationId'] ?? '',
                'descriptionJustification': absence['descriptionJustification'],
                'piecesJointes': absence['piecesJointes'] ?? [],
                'statutJustification': absence['statutJustification'] ?? '',
                'dateValidationJustification':
                    absence['dateValidationJustification'],
                'etat':
                    (absence['isJustification'] == true)
                        ? 'Justifiée'
                        : 'Non justifiée',
              };
            }).toList();

        // Mettre à jour la liste complète des absences
        absences.assignAll(filteredAbsences);

        // Extraire tous les types de pointages pour l'affichage sur la page d'accueil
        // (pas seulement les retards, mais aussi les présences et les absences)
        final pointagesList =
            allAbsences
                .map((absence) {
                  return {
                    'id': absence['id'],
                    'nomCours':
                        absence['nomCours'] ??
                        absence['cours']?['nom'] ??
                        'Matière inconnue',
                    'date': absence['heurePointage'] ?? '',
                    'heurePointage': absence['heurePointage'],
                    'duree':
                        absence['type'] == 'RETARD'
                            ? '${absence['minutesRetard'] ?? '0'} min'
                            : 'Journée entière',
                    'type': absence['type'] ?? 'ABSENCE_COMPLETE',
                    'professeur':
                        absence['professeur'] ??
                        absence['cours']?['enseignant'] ??
                        'Non spécifié',
                    'salle':
                        absence['salle'] ??
                        absence['cours']?['salle'] ??
                        'Non spécifiée',
                    'heureDebut':
                        absence['heureDebut'] ??
                        absence['cours']?['heureDebut'] ??
                        '',
                    'justification': absence['isJustification'] ?? false,
                    'etat':
                        (absence['isJustification'] == true)
                            ? 'Justifiée'
                            : 'Non justifiée',
                  };
                })
                .take(5) // Limiter à 5 éléments
                .toList();

        retards.assignAll(pointagesList);
        return;
      }

      retards.clear();
      absences.clear();
    } catch (e) {
      print('Erreur lors de la récupération des données d\'absence: $e');
      retards.clear();
      absences.clear();
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

  // Méthode pour changer l'onglet
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
