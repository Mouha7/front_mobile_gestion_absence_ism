import 'package:get/get.dart';
import '../../controllers/historique_pointage_controller.dart';

class HistoriquePointageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoriquePointageController>(() => HistoriquePointageController());
  }
}