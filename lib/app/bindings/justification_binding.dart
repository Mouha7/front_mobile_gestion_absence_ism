import 'package:front_mobile_gestion_absence_ism/app/data/services/file_service.dart';
import 'package:get/get.dart';
import '../controllers/justification_controller.dart';
import '../data/services/historique_service.dart';

class JustificationBinding extends Bindings {
  @override
  void dependencies() {
    // S'assurer que le service d'historique est disponible
    if (!Get.isRegistered<HistoriqueService>()) {
      Get.lazyPut<HistoriqueService>(() => HistoriqueService());
    }

    // S'assurer que le service de fichier est disponible
    if (!Get.isRegistered<FileService>()) {
      Get.put(FileService(), permanent: true);
    }

    // Injecter le contrôleur de justification
    Get.lazyPut<JustificationController>(() => JustificationController());
  }
}
