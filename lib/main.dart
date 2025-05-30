import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/bindings/app_binding.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/absence_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/notification_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/retard_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les services
  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  print('📱 Initialisation des services de l\'application...');

  await Get.putAsync<StorageService>(() => StorageService().init());
  print('✅ Service de stockage initialisé');

  Get.put(ApiService(), permanent: true);
  print('✅ Service API initialisé');

  // S'assurer que les autres services sont également initialisés
  if (!Get.isRegistered<AbsenceService>()) {
    Get.put(AbsenceService(Get.find<ApiService>()), permanent: true);
    print('✅ Service Absence initialisé');
  }

  if (!Get.isRegistered<RetardService>()) {
    Get.put(RetardService(Get.find<ApiService>()), permanent: true);
    print('✅ Service Retard initialisé');
  }

  if (!Get.isRegistered<NotificationService>()) {
    Get.put(NotificationService(), permanent: true);
    print('✅ Service Notification initialisé');
  }

  // Effectuer un test de connexion silencieux au démarrage
  try {
    final apiService = Get.find<ApiService>();
    print('🔄 Test de connexion au serveur au démarrage...');
    final isConnected = await apiService.testConnection();
    print(
      '🌐 État de la connexion au démarrage: ${isConnected ? '✅ OK' : '❌ Échec'}',
    );
    print('🔗 URL du serveur: ${apiService.baseUrl}');
  } catch (e) {
    print('❌ Erreur lors du test de connexion initial: $e');
  }
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
