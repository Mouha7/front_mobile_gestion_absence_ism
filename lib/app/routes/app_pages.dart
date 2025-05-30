import 'package:get/get.dart';
import '../modules/vigile/views/historique_pointage_view.dart';
import '../modules/vigile/bindings/historique_pointage_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/vigile/historique',
      page: () => const HistoriquePointageView(),
      binding: HistoriquePointageBinding(),
    ),
    // autres routes...
  ];
}