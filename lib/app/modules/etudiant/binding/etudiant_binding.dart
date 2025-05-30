import 'package:get/get.dart';

import '../../../controllers/etudiant_controller.dart';
import '../../../data/services/api_service.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());
    Get.lazyPut<EtudiantController>(() => EtudiantController());
  }
}
