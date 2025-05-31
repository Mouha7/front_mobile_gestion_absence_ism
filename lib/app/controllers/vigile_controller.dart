import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/sound_manager.dart';
import '../data/models/etudiant.dart';

class VigileController extends GetxController {
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final RxBool isScanning = false.obs;
  final Rx<Etudiant?> etudiantScanne = Rx<Etudiant?>(null);
  final validationVisible = false.obs;
  final RxBool validationSuccess = false.obs;

  // Ajout pour la gestion de l'historique
  final RxBool isLoading = false.obs;
  final RxString searchQuery = "".obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxBool isDateFilterActive = false.obs;
  final RxList<Map<String, dynamic>> historiqueList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredHistorique =
      <Map<String, dynamic>>[].obs;

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

    // Attendre 2 secondes avant de fermer l'écran de validation
    await Future.delayed(const Duration(seconds: 2));

    // Cacher l'écran de validation
    validationVisible.value = false;
    if (!isValid) {
      etudiantScanne.value = null;
    }
  }

  Future<void> traiterCodeQR(String code) async {
    if (isScanning.value) return;
    isScanning.value = true;

    try {
      // Simuler une vérification du QR code
      await Future.delayed(const Duration(milliseconds: 500));

      if (code == 'ETUDIANT-123456') {
        etudiantScanne.value = Etudiant(
          id: '1',
          nom: 'Diallo',
          prenom: 'Amadou',
          email: 'amadou.diallo@ism.edu.sn',
          matricule: code,
          filiere: 'GLSI',
          niveau: 'L3',
          classe: 'L3 GLSI A',
        );
        await _showValidationScreen(true);
      } else {
        await _showValidationScreen(false);
      }
    } catch (e) {
      print('Erreur lors du traitement du QR code: $e');
      await _showValidationScreen(false);
    } finally {
      isScanning.value = false;
    }
  }

  Future<void> verifierMatricule(String matricule) async {
    if (matricule.isEmpty) return;

    try {
      // Simuler une vérification du matricule
      await Future.delayed(const Duration(milliseconds: 500));

      if (matricule == 'ETUDIANT-123456') {
        etudiantScanne.value = Etudiant(
          id: '1',
          nom: 'Diallo',
          prenom: 'Amadou',
          email: 'amadou.diallo@ism.edu.sn',
          matricule: matricule,
          filiere: 'GLSI',
          niveau: 'L3',
          classe: 'L3 GLSI A',
        );
        await _showValidationScreen(true);
      } else {
        await _showValidationScreen(false);
      }

      // Vider le champ de saisie
      matriculeController.clear();
    } catch (e) {
      print('Erreur lors de la vérification du matricule: $e');
      await _showValidationScreen(false);
    }
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return "${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute}";
  }

  // Ajout de mocks pour l'historique du vigile
  List<Map<String, dynamic>> mockHistoriqueVigile = [
    {
      "id": 1,
      "date": "2025-05-20",
      "heure": "08:30",
      "action": "Enregistrement entrée",
      "etudiant": "Fatou Diop",
      "classe": "L2 GLRS A",
      "commentaire": "Arrivée normale",
    },
    {
      "id": 2,
      "date": "2025-05-20",
      "heure": "09:15",
      "action": "Enregistrement retard",
      "etudiant": "Mamadou Sow",
      "classe": "L3 CDSD",
      "commentaire": "Retard de 15 minutes",
    },
    {
      "id": 3,
      "date": "2025-05-21",
      "heure": "10:45",
      "action": "Enregistrement sortie",
      "etudiant": "Aïssatou Ndiaye",
      "classe": "M1 ISI",
      "commentaire": "Sortie anticipée autorisée",
    },
    {
      "id": 4,
      "date": "2025-05-22",
      "heure": "08:00",
      "action": "Enregistrement entrée",
      "etudiant": "Ibrahima Diallo",
      "classe": "L1 RTI",
      "commentaire": "",
    },
    {
      "id": 5,
      "date": "2025-05-22",
      "heure": "14:30",
      "action": "Enregistrement absence",
      "etudiant": "Mariama Bâ",
      "classe": "L2 GLRS B",
      "commentaire": "Absence justifiée par certificat médical",
    },
    {
      "id": 6,
      "date": "2025-05-23",
      "heure": "09:00",
      "action": "Enregistrement entrée",
      "etudiant": "Ousmane Fall",
      "classe": "M2 BDGL",
      "commentaire": "",
    },
    {
      "id": 7,
      "date": "2025-05-23",
      "heure": "11:20",
      "action": "Validation badge",
      "etudiant": "Aminata Touré",
      "classe": "L3 IAGE",
      "commentaire": "Nouveau badge remis",
    },
  ];

  // Méthode pour récupérer l'historique du vigile
  Future<List<Map<String, dynamic>>> getHistoriqueVigile() async {
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(seconds: 1));

    // Retourne les données mockées
    return mockHistoriqueVigile;
  }

  // Méthode pour filtrer l'historique par date
  Future<List<Map<String, dynamic>>> getHistoriqueVigileByDate(
    String date,
  ) async {
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));

    // Filtre les données par date
    return mockHistoriqueVigile.where((item) => item["date"] == date).toList();
  }

  // Méthode pour filtrer l'historique par action
  Future<List<Map<String, dynamic>>> getHistoriqueVigileByAction(
    String action,
  ) async {
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));

    // Filtre les données par type d'action
    return mockHistoriqueVigile
        .where(
          (item) => item["action"].toLowerCase().contains(action.toLowerCase()),
        )
        .toList();
  }

  // Méthodes pour l'historique
  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      final historique = await getHistoriqueVigile();
      historiqueList.assignAll(historique);
      applyFilters(); // Appliquer les filtres actuels
    } catch (e) {
      print('Erreur lors du chargement de l\'historique: $e');
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
            return item["etudiant"].toString().toLowerCase().contains(query) ||
                item["action"].toString().toLowerCase().contains(query) ||
                item["classe"].toString().toLowerCase().contains(query) ||
                item["commentaire"].toString().toLowerCase().contains(query);
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
