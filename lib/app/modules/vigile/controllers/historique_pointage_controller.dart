import 'package:get/get.dart';
import '../../../data/models/pointage.dart';
import '../../../data/services/pointage_service.dart';

class HistoriquePointageController extends GetxController {
  final PointageService _service = Get.find<PointageService>();
  final pointages = <Pointage>[].obs;
  final filteredPointages = <Pointage>[].obs;
  final isLoading = false.obs;
  final searchText = ''.obs;
  final filterType = 'Date'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPointages();
  }

  Future<void> fetchPointages() async {
    isLoading.value = true;
    try {
      // Remplace par l’id du vigile connecté
      final data = await _service.getPointagesVigile("VIGILE_ID");
      pointages.assignAll(data);
      applyFilters();
    } catch (e) {
      pointages.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    applyFilters();
  }

  void onFilterTypeChanged(String? value) {
    if (value != null) {
      filterType.value = value;
      applyFilters();
    }
  }

  void applyFilters() {
    var res = pointages;
    if (searchText.value.isNotEmpty) {
      res = res
          .where((p) =>
              p.matiere.toLowerCase().contains(searchText.value.toLowerCase()) ||
              p.classe.toLowerCase().contains(searchText.value.toLowerCase()) ||
              p.date.contains(searchText.value) ||
              p.heure.contains(searchText.value) ||
              (p.salle?.toLowerCase().contains(searchText.value.toLowerCase()) ?? false))
          .toList()
          .obs;
    }
    // Tri par date décroissante
    if (filterType.value == 'Date') {
      res.sort((a, b) => b.date.compareTo(a.date));
    }
    filteredPointages.assignAll(res);
  }
}