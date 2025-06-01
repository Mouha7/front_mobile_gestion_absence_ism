import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/auth_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/absence_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les services
  await initServices();

  runApp(MyApp());
}

Future<void> initServices() async {
  // Initialiser d'abord le service de stockage
  await Get.putAsync<StorageService>(() => StorageService().init());

  // Puis le service API
  await Get.putAsync<ApiService>(() async => ApiService());

  // Le service d'authentification
  Get.put<AuthService>(AuthService());

  // Enfin le service des absences
  Get.put<AbsenceService>(AbsenceService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gestion des Absences ISM',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    );
  }
}
