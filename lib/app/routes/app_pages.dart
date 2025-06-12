// Importez les autres vues et bindings
import 'package:front_mobile_gestion_absence_ism/app/modules/auth/bindings/auth_binding.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/auth/views/login_view.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/etudiant/bindings/etudiant_binding.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/etudiant/views/home_screen.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/etudiant/views/navigate_screen.dart';

// Imports pour le module vigile
import 'package:front_mobile_gestion_absence_ism/app/modules/vigile/bindings/vigile_binding.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/vigile/views/home_screen.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/vigile/views/historique_view.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/vigile/views/profile_vigile_view.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/etudiant/views/profil_etudiant_view.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/etudiant/views/historique_absence_screen.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/etudiant/views/justification_form_screen.dart';
import 'package:front_mobile_gestion_absence_ism/app/bindings/historique_binding.dart';
import 'package:front_mobile_gestion_absence_ism/app/bindings/justification_binding.dart';
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
    // Routes Étudiant
    GetPage(
      name: Routes.ETUDIANT_DASHBOARD,
      page: () => EtudiantDashboardView(),
      binding: EtudiantBinding(),
    ),
    GetPage(
      name: Routes.ETUDIANT_PROFILE,
      page: () => ProfilEtudiantView(),
      binding: EtudiantBinding(),
    ),
    GetPage(
      name: Routes.ETUDIANT_ABSENCES,
      page: () => EtudiantAbsencesView(),
      binding: HistoriqueBinding(),
    ),
    GetPage(
      name: Routes.ETUDIANT_JUSTIFICATION_FORM,
      page: () => JustificationFormView(),
      binding: JustificationBinding(),
    ),
    GetPage(
      name: Routes.ETUDIANT_NAVIGATE,
      page: () => const EtudiantNavigateView(),
      binding: EtudiantBinding(),
    ),
    // Routes Vigile
    GetPage(
      name: Routes.VIGILE_DASHBOARD,
      page: () => VigileHomeScreen(),
      binding: VigileBinding(),
    ),
    GetPage(
      name: Routes.VIGILE_HISTORIQUE,
      page: () => VigileHistoriqueView(),
      binding: VigileBinding(),
    ),
    GetPage(
      name: Routes.VIGILE_PROFILE,
      page: () => VigileProfileView(),
      binding: VigileBinding(),
    ),
  ];
}
