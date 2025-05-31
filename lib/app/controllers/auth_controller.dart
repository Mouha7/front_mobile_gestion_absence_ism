import 'package:get/get.dart';
import '../data/services/storage_service.dart';
import '../data/services/auth_service.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthService _authService = Get.find<AuthService>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // État de connexion de l'utilisateur
  final isLoggedIn = false.obs;

  // Données de l'utilisateur connecté
  final userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    // Utiliser Future.microtask pour reporter après le build
    Future.microtask(() => checkLoginStatus());
  }

  void checkLoginStatus() {
    isLoggedIn.value = _authService.isLoggedIn();
    if (isLoggedIn.value) {
      final userDataMap = _storageService.getUser();
      if (userDataMap != null) {
        userData.value = null;
      }

      // Rediriger l'utilisateur en fonction de son rôle
      // Utiliser un délai pour éviter les problèmes pendant le build
      Future.delayed(Duration.zero, () => redirectBasedOnRole());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Utiliser le service d'authentification pour la connexion
      final loginResponse = await _authService.login(email, password);
      print('🔍 Réponse de connexion: $loginResponse');
      userData.value = loginResponse;
      isLoggedIn.value = true;

      // Rediriger l'utilisateur en fonction de son rôle
      redirectBasedOnRole();
    } catch (e) {
      String message = e.toString();
      // Simplifier le message d'erreur pour l'utilisateur
      if (message.contains('401') ||
          message.contains('403') ||
          message.contains('Non autorisé') ||
          message.contains('Email ou mot de passe incorrect')) {
        errorMessage.value = 'Email ou mot de passe incorrect';
      } else if (message.contains('Délai d\'attente dépassé') ||
          message.contains('timeout') ||
          message.contains('Erreur de connexion')) {
        errorMessage.value =
            'Problème de connexion au serveur. Vérifiez votre réseau.';
      } else if (message.contains('500')) {
        errorMessage.value = 'Erreur serveur. Réessayez plus tard.';
      } else {
        errorMessage.value = 'Erreur de connexion: $e';
      }
    } finally {
      isLoading.value = false;
    }
  }

  void redirectBasedOnRole() {
    final role = userData.value?['role'];

    // Vérifier si le rôle est null avant d'utiliser le switch
    if (role == null) {
      // Utiliser Future.delayed pour éviter les problèmes avec le build en cours
      Future.delayed(Duration.zero, () => Get.offAllNamed(Routes.LOGIN));
      return;
    }

    // Utiliser Future.delayed pour éviter les problèmes avec le build en cours
    Future.delayed(Duration.zero, () {
      switch (role) {
        case 'ETUDIANT':
          Get.offAllNamed(Routes.ETUDIANT_DASHBOARD);
          break;
        case 'VIGILE':
          Get.offAllNamed(Routes.VIGILE_DASHBOARD);
          break;
        default:
          Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  Future<void> logout() async {
    await _storageService.logout();
    isLoggedIn.value = false;
    userData.value = null;
    Get.offAllNamed(Routes.LOGIN);
  }
}
