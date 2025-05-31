import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';

class HistoriqueService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Récupérer la liste des absences pour l'étudiant connecté
  Future<List<Map<String, dynamic>>> getAbsences() async {
    try {
      final user = _storageService.getUser();
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      final userId = user['id'];

      // Appel à l'API pour récupérer les absences de l'utilisateur
      final response = await _apiService.get('absences?utilisateurId=$userId');

      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des absences: $e');
      return [];
    }
  }

  // Récupérer la liste des retards pour l'étudiant connecté
  Future<List<Map<String, dynamic>>> getRetards() async {
    try {
      final user = _storageService.getUser();
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      final userId = user['id'];

      // Appel à l'API pour récupérer les retards de l'utilisateur
      final response = await _apiService.get('retards?utilisateurId=$userId');

      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des retards: $e');
      return [];
    }
  }

  // Méthode pour soumettre une justification d'absence
  Future<bool> soumettreJustification(
    int absenceId,
    String motif,
    String? pieceJointe,
  ) async {
    try {
      // Mise à jour de l'absence pour la marquer comme justifiée
      final absenceData = {
        'justifie': true,
        'motifJustification': motif,
        'pieceJointe': pieceJointe,
        'dateJustification': DateTime.now().toIso8601String(),
      };

      // Appel à l'API pour mettre à jour l'absence
      await _apiService.put('absences/$absenceId', absenceData);

      return true;
    } catch (e) {
      print('❌ Erreur lors de la soumission de la justification: $e');
      return false;
    }
  }

  // Méthode pour obtenir les détails d'une absence spécifique
  Future<Map<String, dynamic>?> getAbsenceDetails(int absenceId) async {
    try {
      // Appel à l'API pour récupérer les détails de l'absence
      final response = await _apiService.get('absences/$absenceId');

      if (response is Map<String, dynamic>) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des détails de l\'absence: $e');
      return null;
    }
  }

  // Méthode pour envoyer une justification avec un fichier
  Future<bool> envoyerJustificationAvecFichier(
    String absenceId,
    String description,
    String? filePath,
  ) async {
    try {
      // En cas réel, vous devriez télécharger le fichier sur un serveur
      // et obtenir son URL, mais ici nous simulons ce processus
      String? pieceJointe;

      if (filePath != null) {
        // Dans une implémentation réelle, vous téléchargeriez le fichier
        // et obtiendriez son URL à partir de la réponse du serveur
        pieceJointe = filePath;
        print('✅ Pièce jointe simulée: $pieceJointe');
      }

      // Mise à jour de l'absence pour la marquer comme justifiée
      final absenceData = {
        'justifie': true,
        'motifJustification': description,
        'pieceJointe': pieceJointe,
        'dateJustification': DateTime.now().toIso8601String(),
      };

      // Appel à l'API pour mettre à jour l'absence
      final int id = int.parse(absenceId);
      await _apiService.put('absences/$id', absenceData);

      print('✅ Justification envoyée avec succès pour l\'absence $absenceId');
      return true;
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la justification: $e');
      return false;
    }
  }
}
