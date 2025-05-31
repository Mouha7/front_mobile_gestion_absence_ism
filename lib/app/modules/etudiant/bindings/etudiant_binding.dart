import 'package:front_mobile_gestion_absence_ism/app/controllers/auth_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    // Assurer que les services nécessaires sont injectés
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService(), permanent: true);
    }

    // S'assurer que StorageService est disponible
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService(), permanent: true);
    }

    // Injecter une nouvelle instance de EtudiantController
    Get.lazyPut<EtudiantController>(() => EtudiantController(), fenix: true);

    // Injecter le contrôleur d'authentification
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
  }
}
