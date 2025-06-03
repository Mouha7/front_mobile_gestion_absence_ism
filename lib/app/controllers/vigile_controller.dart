import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/sound_manager.dart';
import '../data/services/vigile_service.dart';
import '../data/services/storage_service.dart';
import '../data/models/etudiant.dart';

class VigileController extends GetxController {
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final RxBool isScanning = false.obs;
  final validationVisible = false.obs;
  final RxBool validationSuccess = false.obs;

  // Services nécessaires
  final VigileService _vigileService = Get.find<VigileService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Ajout pour la gestion de l'historique
  final RxBool isLoading = false.obs;
  final RxString searchQuery = "".obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxBool isDateFilterActive = false.obs;
  final RxList<Map<String, dynamic>> historiqueList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredHistorique =
      <Map<String, dynamic>>[].obs;
  final Rx<Etudiant?> etudiantScanne = Rx<Etudiant?>(null);

  // Ajouter une propriété pour stocker les informations de pointage
  final Rx<Map<String, dynamic>?> pointageInfo = Rx<Map<String, dynamic>?>(
    null,
  );

  // Ajoutez cette propriété pour le verrou
  final RxBool isProcessingPointage = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  @override
  void onClose() {
    matriculeController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> _showValidationScreen(bool isValid) async {
    // Mettre à jour l'état de validation
    validationSuccess.value = isValid;
    validationVisible.value = true;

    // Jouer le son approprié
    if (isValid) {
      await SoundManager.playSuccess();
    } else {
      await SoundManager.playError();
    }

    // Afficher l'overlay avec Get.dialog pour qu'il prenne tout l'écran
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF1F1F1F),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isValid ? const Color(0xFF4CAF50) : Colors.red,
                  ),
                  child: Icon(
                    isValid ? Icons.check : Icons.close,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                if (etudiantScanne.value != null) ...[
                  // Ajouter ici les informations de l'étudiant
                ] else ...[
                  Text(
                    isValid ? 'Pointage réussi' : 'Pointage échoué',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      barrierDismissible: false,
    );

    // Attendre 2 secondes avant de fermer l'écran de validation
    await Future.delayed(const Duration(seconds: 2));

    // Fermer le dialog
    Get.back();

    // Réinitialiser etudiantScanne après un délai pour permettre une transition fluide
    if (!isValid) {
      etudiantScanne.value = null;
    }

    validationVisible.value = false;
  }

  // Méthode commune pour les deux modes de pointage
  Future<void> effectuerPointage(
    String matricule, {
    bool fromQR = false,
  }) async {
    // Empêcher les pointages multiples en même temps
    if (isProcessingPointage.value) return;
    isProcessingPointage.value = true;

    try {
      // Activer scanning uniquement si c'est un QR
      if (fromQR) isScanning.value = true;

      // Faire le pointage avec l'API
      final pointageResult = await _fairePointage(matricule);

      // Afficher l'écran de validation approprié
      await _showValidationScreen(pointageResult != null);

      if (pointageResult != null) {
        // Rafraîchir l'historique pour voir le nouveau pointage
        Get.snackbar(
          'Succès',
          'Pointage enregistré avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('❌ Erreur lors du pointage: $e');
      await _showValidationScreen(false);
    } finally {
      isProcessingPointage.value = false;
      if (fromQR) isScanning.value = false;
      matriculeController.clear();
      await refreshData();
    }
  }

  // Remplacez les méthodes existantes par des appels à la méthode commune
  Future<void> traiterCodeQR(String code) async {
    await effectuerPointage(code, fromQR: true);
  }

  Future<void> verifierMatricule(String matricule) async {
    if (matricule.isEmpty) return;
    await effectuerPointage(matricule);
  }

  // Méthode pour faire un pointage via l'API
  Future<Map<String, dynamic>?> _fairePointage(String matriculeEtudiant) async {
    try {
      // Récupérer le vigileId depuis le stockage
      final vigile = _storageService.getUser();
      if (vigile == null || !vigile.containsKey('realId')) {
        print('❌ Erreur: Vigile non connecté ou ID manquant');
        Get.snackbar(
          'Erreur',
          'Impossible de récupérer votre identifiant',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return null;
      }

      final vigileId = vigile['realId']?.toString();
      if (vigileId == null || vigileId == 'null') {
        print('❌ realId du vigile est null ou invalide');
        return null;
      }

      print(
        '🔍 Enregistrement de pointage pour l\'étudiant $matriculeEtudiant par le vigile $vigileId',
      );

      // Construire les données pour l'API
      final pointageData = {
        "matriculeEtudiant": matriculeEtudiant,
        "vigileId": vigileId,
      };

      // Appeler l'API via VigileService
      return await _vigileService.fairePointage(pointageData);
    } catch (e) {
      print('❌ Erreur lors du pointage: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'enregistrer le pointage: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  // Méthode pour récupérer l'historique du vigile
  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      final historique = await _vigileService.getHistoriqueVigile();
      if (historique != null) {
        historiqueList.assignAll(historique);
      } else {
        historiqueList.clear();
        print('⚠️ Aucun historique récupéré');
      }
      applyFilters(); // Appliquer les filtres actuels
    } catch (e) {
      print('❌ Erreur lors du chargement de l\'historique: $e');
      historiqueList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    // Appliquer les filtres (recherche et date)
    var result = List<Map<String, dynamic>>.from(historiqueList);

    // Filtre par recherche
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result =
          result.where((item) {
            return item["etudiantNom"]?.toString().toLowerCase().contains(
                      query,
                    ) ==
                    true ||
                item["matricule"]?.toString().toLowerCase().contains(query) ==
                    true ||
                item["coursNom"]?.toString().toLowerCase().contains(query) ==
                    true;
          }).toList();
    }

    // Filtre par date
    if (isDateFilterActive.value && selectedDate.value != null) {
      final dateStr =
          "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
      result = result.where((item) => item["date"] == dateStr).toList();
    }

    filteredHistorique.assignAll(result);
  }

  void searchHistorique(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void filterByDate(DateTime date) {
    selectedDate.value = date;
    isDateFilterActive.value = true;
    applyFilters();
  }

  void resetDateFilter() {
    selectedDate.value = null;
    isDateFilterActive.value = false;
    applyFilters();
  }
}
