import 'package:get/get.dart';
import '../services/api_service.dart';

class AbsenceService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // Récupérer les absences d'un étudiant
  Future<List<Map<String, dynamic>>> getAbsencesByStudent(
    String studentId,
  ) async {
    try {
      final response = await _apiService.get('absences?etudiantId=$studentId');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('❌ Erreur lors de la récupération des absences: $e');
      return [];
    }
  }

  // Récupérer les absences par classe
  Future<List<Map<String, dynamic>>> getAbsencesByClass(
    String className,
  ) async {
    try {
      final response = await _apiService.get('absences?classe=$className');
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('❌ Erreur lors de la récupération des absences: $e');
      return [];
    }
  }

  // Créer une nouvelle absence
  Future<Map<String, dynamic>> createAbsence(
    Map<String, dynamic> absenceData,
  ) async {
    try {
      final response = await _apiService.post('absences', absenceData);
      return response;
    } catch (e) {
      print('❌ Erreur lors de la création de l\'absence: $e');
      rethrow;
    }
  }

  // Mettre à jour une absence (pour la justification)
  Future<Map<String, dynamic>> updateAbsence(
    String absenceId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await _apiService.put('absences/$absenceId', updateData);
      return response;
    } catch (e) {
      print('❌ Erreur lors de la mise à jour de l\'absence: $e');
      rethrow;
    }
  }

  // Supprimer une absence
  Future<void> deleteAbsence(String absenceId) async {
    try {
      await _apiService.delete('absences/$absenceId');
    } catch (e) {
      print('❌ Erreur lors de la suppression de l\'absence: $e');
      rethrow;
    }
  }
}
