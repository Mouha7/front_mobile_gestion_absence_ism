import 'package:front_mobile_gestion_absence_ism/app/data/models/etudiant.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/login_response.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Méthode d'authentification avec Spring Boot API
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Appel à l'API Spring Boot pour l'authentification
      final response = await _apiService.post('auth/login', {
        'email': email,
        'motDePasse': password,
      });
      print('🔍 Réponse de l\'API: $response');
      if (response == null || response['results'] == null) {
        throw Exception('Réponse d\'authentification invalide');
      }
      final loginResponse = LoginResponse.fromJson(response['results']);
      // Extraire l'ID à partir de redirectEndpoint
      final id = loginResponse.redirectEndpoint.split('/').last;
      final userResponse;
      if (loginResponse.redirectEndpoint == "") {
        userResponse = await _apiService.get('vigile/$id/historique');
      } else {
        userResponse = await _apiService.get('etudiant/$id');
      }

      if (userResponse == null || userResponse['results'] == null) {
        throw Exception('Utilisateur non trouvé');
      }

      print('🔍 Données étudiant: ${userResponse['results']}');
      final user = Etudiant.fromJson(userResponse['results']);

      print('🔍 Utilisateur récupéré: $userResponse');

      await _storageService.saveUser(user.toJson());
      return {
        "nom": user.nom,
        "prenom": user.prenom,
        "email": user.email,
        "role": loginResponse.role,
        "matricule": user.matricule,
        "classe": user.classe,
        "absences": user.absences.map((a) => a.toJson()).toList(),
      };
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      throw Exception('Email ou mot de passe incorrect');
    }
  }

  // Récupérer les données de l'utilisateur connecté
  Future<Map<String, dynamic>> getCurrentUser() async {
    // D'abord vérifier si l'utilisateur est dans le stockage local
    final cachedUser = _storageService.getUser();
    if (cachedUser != null) {
      print('✅ Utilisateur récupéré du cache local');
      return cachedUser;
    }

    // Sinon, récupérer depuis l'API
    final token = _storageService.token;

    if (token == null) {
      throw Exception('Non authentifié');
    }

    try {
      // Récupérer le profil de l'utilisateur connecté avec le token
      final response = await _apiService.get('', requireAuth: true);

      if (response != null) {
        final user = response;

        // Mettre en cache l'utilisateur récupéré
        await _storageService.saveUser(user);

        return user;
      } else {
        throw Exception('Utilisateur non trouvé');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'utilisateur: $e');
      rethrow;
    }
  }

  // Vérifier si l'utilisateur est connecté
  bool isLoggedIn() {
    return _storageService.isLoggedIn();
  }

  // Déconnecter l'utilisateur
  Future<void> logout() async {
    await _storageService.logout();
  }
}
