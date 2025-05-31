import 'package:get/get.dart';
import '../../../controllers/vigile_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/api_service.dart';

class VigileBinding extends Bindings {
  @override
  void dependencies() {
    // S'assurer que les services nécessaires sont injectés
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService(), permanent: true);
    }

    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService(), permanent: true);
    }

    // Injecter les contrôleurs
    Get.lazyPut<VigileController>(() => VigileController(), fenix: true);

    // L'AuthController doit être permanent et immédiatement disponible
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true).onInit();
    }
  }
}
