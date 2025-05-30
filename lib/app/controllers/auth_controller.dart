import 'package:get/get.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Observables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isLoggedIn = false.obs;
  final userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    isLoggedIn.value = _storageService.isLoggedIn();
    if (isLoggedIn.value) {
      userData.value = _storageService.getUser();
      redirectBasedOnRole();
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _apiService.post(
        'auth/login',
        {'email': email, 'password': password},
        requireAuth: false,
      );

      // Vérifier la présence du token et de l'utilisateur
      if (data['token'] == null || data['role'] == null) {
        throw Exception("Authentification échouée. Informations manquantes.");
      }

      await _storageService.setToken(data['token']);
      await _storageService.saveUser(data);

      userData.value = data;
      isLoggedIn.value = true;

      redirectBasedOnRole();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      isLoggedIn.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void redirectBasedOnRole() {
    final role = userData.value?['role']?.toString()?.toUpperCase();

    if (role == 'ETUDIANT') {
      Get.offAllNamed(Routes.ETUDIANT_DASHBOARD);
    } else if (role == 'VIGILE') {
      Get.offAllNamed(Routes.VIGILE_DASHBOARD);
    } else {
      // Si rôle inconnu ou absent, retour au login
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> logout() async {
    await _storageService.logout();
    isLoggedIn.value = false;
    userData.value = null;
    Get.offAllNamed(Routes.LOGIN);
  }
}