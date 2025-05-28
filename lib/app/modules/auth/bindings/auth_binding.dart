import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/storage_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<StorageService>(() => StorageService());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}