import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/absence_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/notification_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/retard_service.dart';
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
    Get.put(AbsenceService(Get.find<ApiService>()), permanent: true);
    Get.put(RetardService(Get.find<ApiService>()), permanent: true);
    Get.put(NotificationService(), permanent: true);
    Get.put(FileService(), permanent: true);

    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.put(EtudiantController(), permanent: true);
  }
}
