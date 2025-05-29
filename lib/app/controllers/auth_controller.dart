import 'package:get/get.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  // État de connexion de l'utilisateur
  final isLoggedIn = false.obs;
  
  // Données de l'utilisateur connecté
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
      
      // Rediriger l'utilisateur en fonction de son rôle
      redirectBasedOnRole();
    }
  }
  
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final data = await _apiService.post('auth/login', {
        'email': email,
        'password': password,
      }, requireAuth: false);
      
      await _storageService.setToken(data['token']);
      await _storageService.saveUser(data);
      
      userData.value = data;
      isLoggedIn.value = true;
      
      // Rediriger l'utilisateur en fonction de son rôle
      redirectBasedOnRole();
      
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  void redirectBasedOnRole() {
    final role = userData.value?['role'];
    
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
  }
  
  Future<void> logout() async {
    await _storageService.logout();
    isLoggedIn.value = false;
    userData.value = null;
    Get.offAllNamed(Routes.LOGIN);
  }
}