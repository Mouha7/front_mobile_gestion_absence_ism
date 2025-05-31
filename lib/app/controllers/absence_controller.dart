import 'package:get/get.dart';
import '../data/services/absence_service.dart';
import '../data/services/api_service.dart';
import '../data/services/auth_service.dart';

class AbsenceController extends GetxController {
  final AbsenceService _absenceService = Get.find<AbsenceService>();
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  final absences = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAbsences();
  }

  Future<void> loadAbsences() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Vérifier si le serveur est disponible
      final serverAvailable = await _apiService.isServerAvailable();
      if (!serverAvailable) {
        errorMessage.value = 'Impossible de se connecter au serveur';
        return;
      }

      // Récupérer l'utilisateur connecté
      final user = await _authService.getCurrentUser();

      // Récupérer les absences en fonction du rôle
      if (user['role'] == 'ETUDIANT') {
        final studentId = user['id'].toString();
        final studentAbsences = await _absenceService.getAbsencesByStudent(
          studentId,
        );
        absences.assignAll(studentAbsences);
      } else if (user['role'] == 'VIGILE') {
        // Pour un vigile, on pourrait récupérer les absences par classe
        final classAbsences = await _absenceService.getAbsencesByClass(
          user['classe'] ?? '',
        );
        absences.assignAll(classAbsences);
      }
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement des absences: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAbsence(Map<String, dynamic> absenceData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _absenceService.createAbsence(absenceData);
      await loadAbsences(); // Recharger les absences
    } catch (e) {
      errorMessage.value = 'Erreur lors de la création de l\'absence: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> justifyAbsence(String absenceId, String justification) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _absenceService.updateAbsence(absenceId, {
        'justified': true,
        'justificationText': justification,
        'justificationDate': DateTime.now().toIso8601String(),
      });

      await loadAbsences(); // Recharger les absences
    } catch (e) {
      errorMessage.value = 'Erreur lors de la justification de l\'absence: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAbsence(String absenceId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _absenceService.deleteAbsence(absenceId);
      await loadAbsences(); // Recharger les absences
    } catch (e) {
      errorMessage.value = 'Erreur lors de la suppression de l\'absence: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
