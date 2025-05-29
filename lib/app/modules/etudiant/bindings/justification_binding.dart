import 'package:front_mobile_gestion_absence_ism/app/controllers/justification_controller.dart';
import 'package:get/get.dart';

class JustificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JustificationController>(() => JustificationController());
  }
}
