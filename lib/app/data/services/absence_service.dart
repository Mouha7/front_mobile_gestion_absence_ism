import 'dart:convert';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:get/get.dart';

class AbsenceService extends GetxService {
  final ApiService _apiService;

  AbsenceService(this._apiService);

  // Récupérer les absences d'un étudiant
  Future<List<Map<String, dynamic>>> fetchAbsencesEtudiant(
    String studentId,
  ) async {
    try {
      final response = await _apiService.get(
        'absences?utilisateurId=$studentId',
      );

      if (response != null) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => item as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Méthode pour filtrer les absences
  List<Map<String, dynamic>> filterAbsences(
    List<Map<String, dynamic>> absences, {
    String? searchQuery,
    DateTime? selectedDate,
  }) {
    if (absences.isEmpty) return [];

    List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(
      absences,
    );

    // Appliquer le filtre de recherche si présent
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result =
          result.where((absence) {
            final matiere = absence['matiere'].toString().toLowerCase();
            final professeur = absence['professeur'].toString().toLowerCase();
            final date = absence['date'].toString().toLowerCase();

            return matiere.contains(query) ||
                professeur.contains(query) ||
                date.contains(query);
          }).toList();
    }

    // Appliquer le filtre de date si présent
    if (selectedDate != null) {
      // Convertir la date sélectionnée en chaîne de caractères au format JJ/MM/YYYY
      final day = selectedDate.day.toString().padLeft(2, '0');
      final month = selectedDate.month.toString().padLeft(2, '0');
      final year = selectedDate.year.toString();
      final dateStr = '$year/$month/$day';

      result =
          result.where((absence) {
            return absence['date'].toString().contains(dateStr);
          }).toList();
    }

    return result;
  }

  // Marquer une absence pour un étudiant
  Future<bool> markAbsence(String studentId, String courseId) async {
    try {
      final response = await _apiService.post('/absences/mark', {
        'studentId': studentId,
        'courseId': courseId,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
