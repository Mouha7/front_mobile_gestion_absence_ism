import 'package:front_mobile_gestion_absence_ism/app/data/models/etudiant.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/login_response.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/vigile.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('auth/login', {
        'email': email,
        'motDePasse': password,
      });
      print('🔍 Réponse de l\'API: $response');
      if (response == null || response['results'] == null) {
        throw Exception('Réponse d\'authentification invalide');
      }
      final loginResponse = LoginResponse.fromJson(response['results']);

      final userResponse;
      String id;

      print('🔍 Role: ${loginResponse.role}');
      print('🔍 RedirectEndpoint: ${loginResponse.redirectEndpoint}');
      print('🔍 Real ID: ${loginResponse.realId}');

      // Extraire l'ID du redirectEndpoint s'il est disponible, sinon utiliser userId

      if (loginResponse.role == 'VIGILE') {
        id = loginResponse.userId;
        print('🔍 Appel API pour le vigile avec ID: $id');
        userResponse = await _apiService.get('vigile/$id');
      } else if (loginResponse.role == 'ETUDIANT') {
        id = loginResponse.realId;
        print('🔍 Appel API pour l\'\u00e9tudiant avec ID: $id');
        userResponse = await _apiService.get('etudiant/$id');
      } else {
        throw Exception(
          'Rôle non supporté dans l\'application mobile: ${loginResponse.role}',
        );
      }

      if (userResponse == null || userResponse['results'] == null) {
        throw Exception('Utilisateur non trouvé');
      }

      print('🔍 Données utilisateur: ${userResponse['results']}');

      dynamic user;
      if (loginResponse.role == 'VIGILE') {
        try {
          user = Vigile.fromJson(userResponse['results']);
          print('🔍 Vigile créé avec succès: ${user.nomComplet}');
        } catch (e) {
          print('🔍 Erreur lors de la création du vigile: $e');
          print('🔍 Structure reçue: ${userResponse['results']}');
          throw Exception('Erreur lors de la création du vigile: $e');
        }
      } else {
        try {
          user = Etudiant.fromJson(userResponse['results']);
          print('🔍 Étudiant créé avec succès: ${user.nomComplet}');
        } catch (e) {
          print('🔍 Erreur lors de la création de l\'\u00e9tudiant: $e');
          print('🔍 Structure reçue: ${userResponse['results']}');
          throw Exception('Erreur lors de la création de l\'\u00e9tudiant: $e');
        }
      }

      print('🔍 Utilisateur récupéré: ${user.toJson()}');

      // Créer les données à sauvegarder
      Map<String, dynamic> returnData = {
        "id": user.id,
        "nom": user.nom,
        "prenom": user.prenom,
        "email": email, // S'assurer que l'email est bien présent ici
        "role": loginResponse.role,
        "token": response["results"]["token"],
      };

      // Ajouter les données spécifiques au rôle
      if (loginResponse.role == 'VIGILE') {
        returnData["badge"] = (user as Vigile).badge;
        returnData["realId"] = loginResponse.realId;
      } else if (loginResponse.role == 'ETUDIANT') {
        Etudiant etudiant = user as Etudiant;
        returnData["matricule"] = etudiant.matricule;
        returnData["classe"] = etudiant.classe;
        returnData["absences"] =
            etudiant.absences.map((a) => a.toJson()).toList();
      }

      // Sauvegarder le même objet qu'on retourne
      // await _storageService.setToken(response["results"]["token"]);
      await _storageService.saveUser(returnData);

      return returnData;
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
      final response = await _apiService.get('');

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
