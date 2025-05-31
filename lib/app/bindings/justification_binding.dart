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

    // Injecter le contrôleur de justification
    Get.lazyPut<JustificationController>(() => JustificationController());
  }
}
