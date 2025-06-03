import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';
import 'package:get/get.dart';

class VigileService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  Future<List<Map<String, dynamic>>?> getHistoriqueVigile() async {
    try {
      final vigile = _storageService.getUser();
      if (vigile == null || !vigile.containsKey('realId')) {
        print('❌ Vigile non trouvé dans le stockage ou realId manquant');
        return null;
      }

      final vigileId = vigile['realId']?.toString();
      if (vigileId == null || vigileId == 'null') {
        print('❌ realId du vigile est null ou invalide');
        return null;
      }

      print('🔍 Récupération de l\'historique pour le vigile ID: $vigileId');

      final response = await _apiService.get('vigile/$vigileId/historique');
      if (response == null || response['results'] == null) {
        print('❌ Réponse invalide de l\'API pour l\'historique du vigile');
        return null;
      }

      // Transformer les résultats en une liste de Map
      List<Map<String, dynamic>> formattedResults =
          (response['results'] as List)
              .map(
                (item) => {
                  'id': item['id'],
                  'etudiantNom':
                      item['etudiantNom'] ??
                      'Non spécifié', // Utiliser le même nom de clé
                  'matricule': item['matricule'] ?? 'Non spécifié',
                  'coursNom':
                      item['coursNom'] ??
                      'Non spécifié', // Utiliser le même nom de clé
                  'date': item['date'] ?? '',
                  'heureArrivee': item['heureArrivee'] ?? '',
                  'minutesRetard': item['minutesRetard'],
                  'typeAbsence': item['typeAbsence'],
                  'action':
                      item['minutesRetard'] != null
                          ? 'Retard de ${item['minutesRetard']} min'
                          : (item['typeAbsence'] != null
                              ? 'Absence'
                              : 'Présence'),
                },
              )
              .toList();
      return formattedResults;
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique: $e');
      return null;
    }
  }

  // Méthode pour faire un pointage via l'API
  Future<Map<String, dynamic>?> fairePointage(
    Map<String, dynamic> pointageData,
  ) async {
    try {
      final response = await _apiService.post('vigile/pointage', pointageData);

      if (response != null &&
          response['status'] == 'CREATED' &&
          response['results'] != null) {
        print('✅ Pointage enregistré avec succès');
        // Transformer les résultats en une liste de Map
        Map<String, dynamic> formattedResults = {
          'id': response['results']['id'],
          'etudiantNom':
              response['results']['etudiantNom'] ??
              'Non spécifié', // Utiliser le même nom de clé
          'matricule': response['results']['matricule'] ?? 'Non spécifié',
          'coursNom':
              response['results']['coursNom'] ??
              'Non spécifié', // Utiliser le même nom de clé
          'date': response['results']['date'] ?? '',
          'heureArrivee': response['results']['heureArrivee'] ?? '',
          'minutesRetard': response['results']['minutesRetard'],
          'typeAbsence': response['results']['typeAbsence'],
          'action':
              response['results']['minutesRetard'] != null
                  ? 'Retard de ${response['results']['minutesRetard']} min'
                  : (response['results']['typeAbsence'] != null
                      ? 'Absence'
                      : 'Présence'),
        };
        return formattedResults;
      } else {
        print(
          '❌ Échec du pointage: ${response?['message'] ?? "Erreur inconnue"}',
        );
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors du pointage: $e');
      return null;
    }
  }
}
