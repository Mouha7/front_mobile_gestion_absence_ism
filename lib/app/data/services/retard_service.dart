import 'dart:convert';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:get/get.dart';

class RetardService extends GetxService {
  final ApiService _apiService;

  RetardService(this._apiService);

  // Récupérer les retards d'un étudiant
  Future<List<Map<String, dynamic>>> fetchRetardsEtudiant(
    String studentId,
  ) async {
    try {
      final response = await _apiService.get(
        'retards?utilisateurId=$studentId',
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

  // Marquer un retard pour un étudiant
  Future<bool> markRetard(
    String studentId,
    String courseId,
    int dureeMinutes,
  ) async {
    try {
      final response = await _apiService.post('/retards/mark', {
        'studentId': studentId,
        'courseId': courseId,
        'dureeMinutes': dureeMinutes,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
