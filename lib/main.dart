import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
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

  Get.put(ApiService());
  print('✅ Service API initialisé');

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    );
  }
}
