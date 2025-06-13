part of 'app_pages.dart';

abstract class Routes {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SPLASH = '/splash';

  // Routes Étudiant
  static const ETUDIANT_DASHBOARD = '/etudiant/dashboard';
  static const ETUDIANT_NAVIGATE = '/etudiant/navigate';
  static const ETUDIANT_ABSENCES = '/etudiant/absences';
  static const ETUDIANT_JUSTIFICATION = '/etudiant/justification';
  static const ETUDIANT_JUSTIFICATION_FORM = '/etudiant/justification/form';
  static const ETUDIANT_PROFILE = '/etudiant/profile';

  // Routes Vigile
  static const VIGILE_DASHBOARD = '/vigile/dashboard';
  static const VIGILE_HISTORIQUE = '/vigile/historique';
  static const VIGILE_ETAT = '/vigile/etat';
  static const VIGILE_PROFILE = '/vigile/profile';
}
