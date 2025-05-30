import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/absence_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:get/get.dart';

class EtudiantController extends GetxController {
  // Utiliser l'API service pour communiquer avec json-server
  final ApiService _apiService = Get.find<ApiService>();
  final AbsenceService _absenceService = Get.find<AbsenceService>();
  final RxString matricule = 'ISM2025001'.obs;
  final RxList<Map<String, dynamic>> retards = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> absences = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isServerConnected = false.obs;
  final RxBool showConnectionStatus = true.obs;

  Timer? _connectionStatusTimer;

  @override
  void onInit() {
    super.onInit();
    checkServerConnection();

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
      isServerConnected.value = await _apiService.testConnection();

      if (isServerConnected.value) {
        fetchRetards();
        fetchAbsences();

        // Afficher l'URL du serveur en cas de succès
        Get.snackbar(
          'Connexion établie',
          'Connecté au serveur: ${_apiService.baseUrl}',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Erreur de connexion',
          'Impossible de se connecter au serveur. Vérifiez que le serveur est démarré et configurez l\'URL correctement.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
      // Afficher l'indicateur de connexion et démarrer le timer
      _hideConnectionStatusAfterDelay();
    } catch (e) {
      print('Erreur lors de la vérification de la connexion: $e');
      isServerConnected.value = false;
      // Afficher l'indicateur de connexion et démarrer le timer
      _hideConnectionStatusAfterDelay();
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour changer l'URL du serveur
  void setServerUrl(String url) {
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

      // Récupérer les retards depuis le serveur json
      final response = await _apiService.get('retards?utilisateurId=1');

      if (response != null) {
        final List<dynamic> jsonData = json.decode(response.body);
        final data =
            jsonData.map((item) => item as Map<String, dynamic>).toList();
        retards.assignAll(data);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de récupérer les retards: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour récupérer les absences de l'étudiant
  Future<void> fetchAbsences() async {
    try {
      isLoading.value = true;

      // Récupérer les absences depuis le serveur json
      final response = await _apiService.get('absences?utilisateurId=1');

      if (response != null) {
        final List<dynamic> jsonData = json.decode(response.body);
        final data =
            jsonData.map((item) => item as Map<String, dynamic>).toList();
        absences.assignAll(data);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de récupérer les absences: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      print('Erreur dans fetchAbsences: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
