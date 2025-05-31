import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/services/historique_service.dart';
import 'dart:async';
import 'package:front_mobile_gestion_absence_ism/app/utils/helpers/snackbar_utils.dart';

class HistoriqueController extends GetxController {
  // Services
  final HistoriqueService _historiqueService = Get.find<HistoriqueService>();

  // Observables
  final isLoading = false.obs;
  final isServerConnected = true.obs;
  final absences = <Map<String, dynamic>>[].obs;
  final retards = <Map<String, dynamic>>[].obs;
  final filteredAbsences = <Map<String, dynamic>>[].obs;
  final searchQuery = ''.obs;
  final isDateFilterActive = false.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  @override
  void onReady() {
    super.onReady();
    // Initialisation des données au démarrage
    refreshData();
  }

  // Rafraîchir les données
  Future<void> refreshData() async {
    try {
      isLoading.value = true;

      // Simulation d'un délai réseau
      await Future.delayed(const Duration(seconds: 1));

      // Vérification de la connexion au serveur (à remplacer par une vraie vérification)
      isServerConnected.value = await _checkServerConnection();

      if (isServerConnected.value) {
        // Récupération des absences et retards (mode mock)
        await _fetchMockData();

        // Appliquer les filtres actuels
        _applyFilters();
      } else {
        // Afficher un message d'erreur si le serveur n'est pas disponible
        SnackbarUtils.showError(
          'Erreur de connexion',
          'Impossible de se connecter au serveur. Vérifiez votre connexion internet.',
        );
      }
    } catch (e) {
      print('❌ Erreur lors du rafraîchissement des données: $e');
      isServerConnected.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode privée pour vérifier la connexion au serveur
  Future<bool> _checkServerConnection() async {
    try {
      // TODO: Implémenter la vérification de connexion au serveur
      // Par exemple, faire une requête ping vers le serveur
      await Future.delayed(const Duration(milliseconds: 500));

      // Pour démonstration, on retourne true (connecté)
      return true;
    } catch (e) {
      print('Erreur de connexion au serveur: $e');
      return false;
    }
  }

  // Méthode privée pour récupérer les données fictives
  Future<void> _fetchMockData() async {
    try {
      // Données fictives pour les absences
      final mockAbsences = [
        {
          'id': 1,
          'matiere': 'Programmation Mobile Flutter',
          'date': '31 Mai 2025',
          'duree': 'Journée entière',
          'professeur': 'Dr. Ndiaye',
          'justifie': false,
          'type': 'Absence',
          'etat': 'Non justifiée',
          'salle': 'Salle 201',
        },
        {
          'id': 2,
          'matiere': 'Intelligence Artificielle',
          'date': '30 Mai 2025',
          'duree': 'Matin',
          'professeur': 'Prof. Diop',
          'justifie': true,
          'motifJustification': 'Rendez-vous médical',
          'dateJustification': '30 Mai 2025',
          'type': 'Absence',
          'etat': 'Justifiée',
          'salle': 'Labo Info',
        },
        {
          'id': 3,
          'matiere': 'Sécurité Informatique',
          'date': '29 Mai 2025',
          'duree': 'Après-midi',
          'professeur': 'Dr. Sow',
          'justifie': false,
          'type': 'Absence',
          'etat': 'En attente',
          'salle': 'Amphi A',
        },
      ];

      // Données fictives pour les retards
      final mockRetards = [
        {
          'id': 101,
          'matiere': 'Architecture Cloud',
          'date': '31 Mai 2025',
          'duree': '15 min',
          'professeur': 'M. Fall',
          'type': 'Retard',
          'etat': 'Non justifié',
          'salle': 'Salle 305',
          'heureArrivee': '08:15',
          'heureDebut': '08:00',
        },
        {
          'id': 102,
          'matiere': 'DevOps & CI/CD',
          'date': '30 Mai 2025',
          'duree': '10 min',
          'professeur': 'Mme Ba',
          'type': 'Retard',
          'etat': 'Justifié',
          'salle': 'Labo DevOps',
          'heureArrivee': '14:10',
          'heureDebut': '14:00',
          'motifJustification': 'Problème de transport',
          'dateJustification': '30 Mai 2025',
        },
      ];

      absences.assignAll(mockAbsences);
      retards.assignAll(mockRetards);

      print(
        '✅ Données mock chargées avec succès: ${absences.length} absences, ${retards.length} retards',
      );
    } catch (e) {
      print('❌ Erreur lors du chargement des données mock: $e');
      absences.clear();
      retards.clear();
    }
  }

  // Rechercher dans les absences
  void searchAbsences(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  // Filtrer par date
  void filterByDate(DateTime date) {
    selectedDate.value = date;
    isDateFilterActive.value = true;
    _applyFilters();
  }

  // Réinitialiser le filtre de date
  void resetDateFilter() {
    selectedDate.value = null;
    isDateFilterActive.value = false;
    _applyFilters();
  }

  // Appliquer les filtres (recherche et date)
  void _applyFilters() {
    List<Map<String, dynamic>> result = List.from(absences);

    // Filtrer par texte de recherche
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result =
          result.where((absence) {
            final matiere = absence['matiere']?.toString().toLowerCase() ?? '';
            final professeur =
                absence['professeur']?.toString().toLowerCase() ?? '';
            final date = absence['date']?.toString().toLowerCase() ?? '';

            return matiere.contains(query) ||
                professeur.contains(query) ||
                date.contains(query);
          }).toList();
    }

    // Filtrer par date
    if (isDateFilterActive.value && selectedDate.value != null) {
      final formattedDate = _formatDateForComparison(selectedDate.value!);

      result =
          result.where((absence) {
            final absenceDate = absence['date']?.toString() ?? '';
            return absenceDate.contains(formattedDate);
          }).toList();
    }

    filteredAbsences.assignAll(result);
  }

  // Formater la date pour la comparaison
  String _formatDateForComparison(DateTime date) {
    // Cette méthode doit être adaptée au format de date utilisé dans votre API
    // Par exemple, si vos dates sont au format "YYYY/MM/DD"
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  // Soumettre une justification
  Future<bool> submitJustification(
    int absenceId,
    String motif,
    String? pieceJointe,
  ) async {
    try {
      isLoading.value = true;

      // Simulation d'un délai réseau
      await Future.delayed(const Duration(seconds: 1));

      // Vérification de la connexion au serveur
      isServerConnected.value = await _checkServerConnection();

      if (!isServerConnected.value) {
        SnackbarUtils.showError(
          'Erreur de connexion',
          'Impossible de soumettre la justification. Vérifiez votre connexion internet.',
        );
        return false;
      }

      // Simuler une soumission réussie (dans un cas réel, on appellerait le service)
      print(
        '✅ Justification soumise avec succès - Absence ID: $absenceId, Motif: $motif',
      );

      // Mise à jour locale des données pour refléter la justification
      final index = absences.indexWhere(
        (absence) => absence['id'] == absenceId,
      );
      if (index != -1) {
        final updatedAbsence = Map<String, dynamic>.from(absences[index]);
        updatedAbsence['justifie'] = true;
        updatedAbsence['motifJustification'] = motif;
        updatedAbsence['pieceJointe'] = pieceJointe;
        updatedAbsence['dateJustification'] = DateTime.now()
            .toString()
            .substring(0, 10);

        absences[index] = updatedAbsence;

        // Appliquer les filtres pour mettre à jour la liste filtrée
        _applyFilters();
      }

      return true;
    } catch (e) {
      print('❌ Erreur lors de la soumission de la justification: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Obtenir les détails d'une absence
  Future<Map<String, dynamic>?> getAbsenceDetails(int absenceId) async {
    try {
      isLoading.value = true;

      // Simulation d'un délai réseau
      await Future.delayed(const Duration(milliseconds: 500));

      // Chercher l'absence dans la liste locale
      final absence = absences.firstWhere(
        (absence) => absence['id'] == absenceId,
        orElse: () => <String, dynamic>{},
      );

      if (absence.isEmpty) {
        print('❌ Absence non trouvée: ID $absenceId');
        return null;
      }

      print('✅ Détails de l\'absence récupérés: ID $absenceId');
      return Map<String, dynamic>.from(absence);
    } catch (e) {
      print('❌ Erreur lors de la récupération des détails: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Variables pour la justification
  final description = ''.obs;
  final absenceId = ''.obs;
  final isSubmitting = false.obs;
  final Rx<dynamic> selectedFile = Rx<dynamic>(null);

  // Méthode pour prendre une photo via la caméra
  Future<void> pickFromCamera() async {
    try {
      // Simuler la sélection d'une photo depuis la caméra
      // Dans une implémentation réelle, utilisez image_picker ou un package similaire
      await Future.delayed(const Duration(seconds: 1));

      // Simuler un fichier sélectionné (dans une application réelle, ce serait un File)
      selectedFile.value = DummyFile(
        '/storage/emulated/0/DCIM/Camera/photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      print('✅ Photo prise depuis la caméra');
    } catch (e) {
      print('❌ Erreur lors de la prise de photo: $e');
      SnackbarUtils.showError(
        'Erreur',
        'Impossible de prendre une photo. Veuillez réessayer.',
      );
    }
  }

  // Méthode pour sélectionner un document depuis l'appareil
  Future<void> pickFromDevice() async {
    try {
      // Simuler la sélection d'un fichier depuis l'appareil
      // Dans une implémentation réelle, utilisez file_picker ou un package similaire
      await Future.delayed(const Duration(seconds: 1));

      // Simuler un fichier sélectionné (dans une application réelle, ce serait un File)
      selectedFile.value = DummyFile(
        '/storage/emulated/0/Documents/justification_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      print('✅ Document sélectionné depuis l\'appareil');
    } catch (e) {
      print('❌ Erreur lors de la sélection du document: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner le document. Veuillez réessayer.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Méthode pour envoyer une justification
  Future<bool> envoyerJustification() async {
    try {
      isSubmitting.value = true;

      if (description.value.isEmpty) {
        Get.snackbar(
          'Erreur',
          'Veuillez saisir une description pour votre justification',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Préparer le chemin du fichier s'il est sélectionné
      String? filePath;
      if (selectedFile.value != null) {
        filePath = selectedFile.value.path;
      }

      // Appeler le service pour envoyer la justification
      final success = await _historiqueService.envoyerJustificationAvecFichier(
        absenceId.value,
        description.value,
        filePath,
      );

      if (success) {
        SnackbarUtils.showSuccess(
          'Succès',
          'Votre justification a été envoyée avec succès',
        );

        // Réinitialiser les champs
        description.value = '';
        selectedFile.value = null;

        // Rafraîchir les données
        await refreshData();

        return true;
      } else {
        Get.snackbar(
          'Erreur',
          'Une erreur est survenue lors de l\'envoi de votre justification',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la justification: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}

// Classe fictive pour simuler un fichier
class DummyFile {
  final String path;

  DummyFile(this.path);
}
