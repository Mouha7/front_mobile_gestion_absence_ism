import 'package:front_mobile_gestion_absence_ism/app/utils/helpers/date_formatter.dart';
import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';

class HistoriqueService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Récupérer l'ID de l'utilisateur connecté
  String? _getUserId() {
    final user = _storageService.getUser();
    if (user == null || !user.containsKey('id')) {
      print('❌ Erreur: Aucun utilisateur connecté ou ID manquant');
      return null;
    }
    return user['id'].toString();
  }

  // Récupérer la liste des absences pour l'étudiant connecté
  Future<List<Map<String, dynamic>>> getAbsences() async {
    try {
      final userId = _getUserId();
      
      if (userId == null) {
        throw Exception('Veuillez vous reconnecter pour accéder à vos absences');
      }

      // Appel à l'API pour récupérer les absences de l'utilisateur
      final response = await _apiService.get(
        'etudiant/$userId/absences',
      );

      if (response != null &&
          response['results'] != null &&
          response['status'] == 'OK') {
        final List<dynamic> results = response['results'];
        // Transformer les résultats en format attendu par l'interface
        return results.map((item) {
          final coursData = item['cours'] ?? {};
          print("⬇️⬇️ Justification service: ${item['isJustification']}");
          return {
            'id': item['id'],
            'matiere': item['nomCours'] ?? coursData['matiereNom'] ?? coursData['nom'] ?? 'Cours inconnu',
            'date': DateFormatter.formatDate(item['heurePointage'] ?? ''),
            'duree': item['type'] == 'RETARD'
                ? '${item['minutesRetard'] ?? 0} min'
                : 'Journée entière',
            'professeur': item['professeur'] ?? coursData['enseignant'] ?? 'Non spécifié',
            'justifie': item['isJustification'] ?? false,
            'type': item['type'] ?? 'ABSENCE',
            'etat': item['isJustification'] ? 'Justifiée' : 'Non justifiée',
            'salle': item['salle'] ?? coursData['salle'] ?? 'Non spécifiée',
            'heureDebut': item['heureDebut'] ?? DateFormatter.formatTime(coursData['heureDebut']) ?? '',
            'heurePointage': item['heurePointage'] ?? '',
          };
        }).toList();
      } else {
        print('❌ Format de réponse invalide: $response');
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des absences: $e');
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
      final userId = _getUserId();
      if (userId == null) {
        throw Exception('Veuillez vous reconnecter pour accéder aux détails de l\'absence');
      }

      // Récupérer toutes les absences, puis filtrer celle qui nous intéresse
      final response = await _apiService.get(
        'etudiant/$userId/absences',
      );

      if (response != null &&
          response['results'] != null &&
          response['status'] == 'OK') {
        final List<dynamic> results = response['results'];

        // Trouver l'absence avec l'ID spécifié
        final absence = results.firstWhere(
          (item) => item['id'] == absenceId.toString(),
          orElse: () => null,
        );

        if (absence != null) {
          final coursData = absence['cours'] ?? {};
          return {
            'id': absence['id'],
            'matiere':
                coursData['matiereNom'] ?? coursData['nom'] ?? 'Cours inconnu',
            'date': DateFormatter.formatDate(absence['heurePointage'] ?? ''),
            'duree':
                absence['type'] == 'RETARD'
                    ? '${absence['minutesRetard'] ?? 0} min'
                    : 'Journée entière',
            'professeur': coursData['enseignant'] ?? 'Non spécifié',
            'justifie': absence['isJustification'] ?? false,
            'type': absence['type'] ?? 'ABSENCE',
            'etat': absence['isJustification'] ? 'Justifiée' : 'Non justifiée',
            'salle': coursData['salle'] ?? 'Non spécifiée',
            'heureDebut': coursData['heureDebut'] ?? '',
            'heureFin': coursData['heureFin'] ?? '',
            'classeNom': coursData['classeNom'] ?? '',
          };
        }
      }

      print('❌ Absence non trouvée avec ID: $absenceId');
      return null;
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
      // Préparer le chemin du fichier s'il est sélectionné
      String? pieceJointeUrl;
      if (filePath != null) {
        // Dans une implémentation réelle, vous téléchargeriez le fichier
        // et obtiendriez son URL à partir de la réponse du serveur
        pieceJointeUrl = filePath;
        print('✅ Pièce jointe à envoyer: $pieceJointeUrl');
      }

      // Préparer les données de la justification
      final justificationData = {
        'absenceId': absenceId,
        'motif': description,
        'pieceJointe': pieceJointeUrl,
        'dateJustification': DateTime.now().toIso8601String(),
      };

      // Appel à l'API pour soumettre la justification
      final response = await _apiService.post(
        'etudiant/justification',
        justificationData,
      );

      if (response != null && response['status'] == 'OK') {
        print('✅ Justification envoyée avec succès pour l\'absence $absenceId');
        return true;
      } else {
        print(
          '❌ Échec de l\'envoi de la justification: ${response?['message'] ?? "Erreur inconnue"}',
        );
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la justification: $e');
      return false;
    }
  }
}