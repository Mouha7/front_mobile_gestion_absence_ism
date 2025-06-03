import 'package:front_mobile_gestion_absence_ism/app/data/services/vigile_service.dart';
import 'package:get/get.dart';
import '../../../controllers/vigile_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/api_service.dart';

class VigileBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Injecter d'abord les services de base
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService(), permanent: true);
    }

    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService(), permanent: true);
    }

    // 2. IMPORTANT: Toujours injecter VigileService avant VigileController
    // Supprimer la condition pour garantir que le service est toujours réinitialisé
    Get.put<VigileService>(VigileService(), permanent: true);

    // 3. Injecter le contrôleur après le service
    if (!Get.isRegistered<VigileController>()) {
      Get.put<VigileController>(VigileController(), permanent: true);
    }

    // L'AuthController doit être permanent et immédiatement disponible
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true).onInit();
    }
  }
}
