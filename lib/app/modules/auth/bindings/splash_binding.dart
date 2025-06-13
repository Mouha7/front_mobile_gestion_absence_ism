import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
