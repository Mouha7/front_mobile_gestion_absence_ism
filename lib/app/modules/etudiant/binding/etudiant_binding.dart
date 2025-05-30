import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/absence_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/notification_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/retard_service.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    // Assurer que les services nécessaires sont injectés
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService(), permanent: true);
    }

    // Injecter AbsenceService s'il n'est pas déjà injecté
    if (!Get.isRegistered<AbsenceService>()) {
      Get.put(AbsenceService(Get.find<ApiService>()), permanent: true);
    }

    // Injecter RetardService s'il n'est pas déjà injecté
    if (!Get.isRegistered<RetardService>()) {
      Get.put(RetardService(Get.find<ApiService>()), permanent: true);
    }

    // Injecter NotificationService s'il n'est pas déjà injecté
    if (!Get.isRegistered<NotificationService>()) {
      Get.put(NotificationService(), permanent: true);
    }

    // Utilisation de l'instance de EtudiantController
    if (!Get.isRegistered<EtudiantController>()) {
      Get.lazyPut<EtudiantController>(() => EtudiantController());
    }
  }
}
