import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/bindings/app_binding.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser uniquement les services essentiels avant de lancer l'application
  // Les autres services seront initialisés par AppBinding
  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  print('📱 Initialisation des services de l\'application...');

  // Le service de stockage doit être initialisé en premier car il a une méthode d'initialisation asynchrone
  await Get.putAsync<StorageService>(() => StorageService().init());
  print('✅ Service de stockage initialisé');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gestion des Absences ISM',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(), // Ajouter le binding principal ici
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    );
  }
}
