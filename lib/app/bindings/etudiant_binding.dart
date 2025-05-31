import 'package:get/get.dart';
import '../controllers/etudiant_controller.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EtudiantController>(
      () => EtudiantController(),
      fenix: true, // Permet de conserver l'instance même si la page est fermée
    );
  }
}
