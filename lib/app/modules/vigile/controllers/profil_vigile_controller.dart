import 'package:get/get.dart';
import '../../../data/models/vigile.dart';
import '../../../data/services/vigile_service.dart';

class ProfilVigileController extends GetxController {
  final VigileService _service = Get.find<VigileService>();
  final vigile = Rxn<Vigile>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      // Remplace par l'id du vigile connecté (récupéré via storage ou session)
      final data = await _service.getVigileProfile("VIGILE_ID");
      vigile.value = data;
    } catch (e) {
      vigile.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    // Ajoute ici la logique de déconnexion (clear storage, navigation, etc.)
  }
}