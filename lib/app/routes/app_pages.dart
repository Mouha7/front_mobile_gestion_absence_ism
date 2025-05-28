// Importez les autres vues et bindings
import 'package:front_mobile_gestion_absence_ism/app/modules/auth/bindings/auth_binding.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/auth/views/login_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    // GetPage(
    //   name: Routes.SIGNUP,
    //   page: () => SignupView(),
    //   binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: Routes.ETUDIANT_DASHBOARD,
    //   page: () => EtudiantDashboardView(),
    //   binding: EtudiantBinding(),
    // ),
    // GetPage(
    //   name: Routes.ETUDIANT_ABSENCES,
    //   page: () => EtudiantAbsencesView(),
    //   binding: EtudiantBinding(),
    // ),
    // Ajoutez les autres routes ici
  ];
}