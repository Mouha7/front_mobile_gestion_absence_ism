import 'package:front_mobile_gestion_absence_ism/app/controllers/absence_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/justification_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/vigile_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/vigile_service.dart';
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
    Get.put(VigileService(), permanent: true);
    
    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.put(AbsenceController(), permanent: true);
    Get.put(EtudiantController(), permanent: true);
    Get.put(JustificationController(), permanent: true);
    Get.put(VigileController(), permanent: true);
  }
}