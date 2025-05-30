import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:get/get.dart';

class AbsenceService extends GetxService {
  final ApiService _apiService;

  AbsenceService(this._apiService);

  Future<List<dynamic>> fetchAbsencesEtudiant(String studentId) async {
    try {
      final response = await _apiService.get('absences?utilisateurId=$studentId');
      return response;
    } catch (e) {
      return [];
    }
  }

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