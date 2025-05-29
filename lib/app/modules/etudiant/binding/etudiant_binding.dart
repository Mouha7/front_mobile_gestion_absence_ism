import 'package:get/get.dart';

import '../../../controllers/etudiant_controller.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EtudiantController>(() => EtudiantController());
  }
}