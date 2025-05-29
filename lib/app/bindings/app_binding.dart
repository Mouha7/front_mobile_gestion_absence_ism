import 'package:front_mobile_gestion_absence_ism/app/controllers/justification_controller.dart';
import 'package:get/get.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../data/services/file_service.dart';
import '../controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(StorageService(), permanent: true);
    Get.put(ApiService(), permanent: true);
    Get.put(FileService(), permanent: true);
    
    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.put(JustificationController(), permanent: true);
  }
}