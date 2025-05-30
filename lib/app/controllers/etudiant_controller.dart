import 'dart:async';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/absence_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/retard_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/notification_service.dart';
import 'package:get/get.dart';

class EtudiantController extends GetxController {
  // Services
  final ApiService _apiService = Get.find<ApiService>();
  final AbsenceService _absenceService = Get.find<AbsenceService>();
  final RetardService _retardService = Get.find<RetardService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final RxString matricule = 'ISM2025001'.obs;
  final RxList<Map<String, dynamic>> retards = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> absences = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isServerConnected = false.obs;
  final RxBool showConnectionStatus = true.obs;

  // Variables pour la recherche
  final RxString searchQuery = ''.obs;
  final RxList<Map<String, dynamic>> filteredAbsences =
      <Map<String, dynamic>>[].obs;

  // Variables pour le filtrage par date
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxBool isDateFilterActive = false.obs;

  Timer? _connectionStatusTimer;

  @override
  void onInit() {
    super.onInit();
    checkServerConnection();
    // Initialiser la liste filtrée
    filteredAbsences.assignAll(absences);
    // Réinitialiser les filtres de date
    resetDateFilter();
    // Masquer l'indicateur de connexion après 5 secondes
    _hideConnectionStatusAfterDelay();
  }

  @override
  void onClose() {
    _connectionStatusTimer?.cancel();
    super.onClose();
  }

  void _hideConnectionStatusAfterDelay() {
    _connectionStatusTimer?.cancel();
    showConnectionStatus.value = true;
    _connectionStatusTimer = Timer(Duration(seconds: 10), () {
      showConnectionStatus.value = false;
    });
  }

  // Méthode pour vérifier la connexion au serveur
  Future<void> checkServerConnection() async {
    isLoading.value = true;
    try {
      // L'API service reste responsable de tester la connexion
      isServerConnected.value = await _apiService.testConnection();

      if (isServerConnected.value) {
        // Si la connexion est établie, récupérer les données via les services spécifiques
        fetchRetards();
        fetchAbsences();

        // Utiliser le service de notification pour afficher le succès
        _notificationService.showSuccess(
          'Connexion établie',
          'Connecté au serveur: ${_apiService.baseUrl}',
        );
      } else {
        // Utiliser le service de notification pour afficher l'erreur
        _notificationService.showError(
          'Erreur de connexion',
          'Impossible de se connecter au serveur. Vérifiez que le serveur est démarré et configurez l\'URL correctement.',
        );
      }
      // Afficher l'indicateur de connexion et démarrer le timer
      _hideConnectionStatusAfterDelay();
    } catch (e) {
      isServerConnected.value = false;
      // Afficher l'indicateur de connexion et démarrer le timer
      _hideConnectionStatusAfterDelay();
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour changer l'URL du serveur
  void setServerUrl(String url) {
    // Seul l'ApiService doit être responsable de gérer l'URL du serveur
    _apiService.setBaseUrl(url);
    checkServerConnection();
  }

  // Méthode pour rafraîchir les données
  Future<void> refreshData() async {
    // Afficher l'indicateur de connexion lors du rafraîchissement
    showConnectionStatus.value = true;
    _hideConnectionStatusAfterDelay();

    if (isServerConnected.value) {
      await fetchRetards();
      await fetchAbsences();
    } else {
      await checkServerConnection();
    }
  }

  // Méthode pour récupérer les retards de l'étudiant
  Future<void> fetchRetards() async {
    try {
      isLoading.value = true;

      // Utiliser le service de retard pour récupérer les données
      final data = await _retardService.fetchRetardsEtudiant('1');
      retards.assignAll(data);
    } catch (e) {
      // Utiliser le service de notification pour afficher l'erreur
      _notificationService.showInfo(
        'Erreur',
        'Impossible de récupérer les retards: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour récupérer les absences de l'étudiant
  Future<void> fetchAbsences() async {
    try {
      isLoading.value = true;

      // Utiliser le service d'absence pour récupérer les données
      final data = await _absenceService.fetchAbsencesEtudiant('1');
      absences.assignAll(data);

      // Appliquer les filtres actuels (recherche et date)
      _applyFilters();
    } catch (e) {
      // Utiliser le service de notification pour afficher l'erreur
      _notificationService.showError(
        'Erreur',
        'Impossible de récupérer les absences: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour rechercher dans les absences
  void searchAbsences(String query) {
    searchQuery.value = query.toLowerCase();
    _applyFilters();
  }

  // Méthode pour filtrer par date
  void filterByDate(DateTime? date) {
    selectedDate.value = date;
    isDateFilterActive.value = date != null;
    _applyFilters();
  }

  // Méthode pour réinitialiser le filtre de date
  void resetDateFilter() {
    selectedDate.value = null;
    isDateFilterActive.value = false;
    _applyFilters();
  }

  // Méthode privée pour appliquer tous les filtres actifs
  void _applyFilters() {
    // Utiliser le service d'absence pour filtrer les absences
    final filteredResults = _absenceService.filterAbsences(
      absences,
      searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
      selectedDate: isDateFilterActive.value ? selectedDate.value : null,
    );

    // Mettre à jour la liste filtrée
    filteredAbsences.assignAll(filteredResults);
  }
}
