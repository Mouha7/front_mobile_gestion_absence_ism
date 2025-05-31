import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/historique_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/historique_service.dart';

class HistoriqueBinding extends Bindings {
  @override
  void dependencies() {
    // Enregistrer d'abord le service
    Get.lazyPut<HistoriqueService>(() => HistoriqueService());

    // Puis enregistrer le contrôleur qui dépend du service
    Get.lazyPut<HistoriqueController>(() => HistoriqueController());
  }
}
