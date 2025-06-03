import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/auth_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/absence_service.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/utilisateur.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/etudiant.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/vigile.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/absence.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/cours.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/justification.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/pointage.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/pointage_result.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/models/historique_vigile_response.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les services
  await initServices();
  
  runApp(const MyApp());
}

/// Initialise tous les services nécessaires pour l'application
Future<void> initServices() async {
  // Initialiser Hive
  await Hive.initFlutter();
  
  // Enregistrer les adaptateurs Hive
  await registerHiveAdapters();
  
  // Initialiser le service de stockage Hive
  await Get.putAsync<StorageService>(() => StorageService().init());

  // Initialiser les autres services
  await Get.putAsync<ApiService>(() async => ApiService());
  Get.put<AuthService>(AuthService());
  Get.put<AbsenceService>(AbsenceService());
}

/// Enregistre tous les adaptateurs Hive pour la persistance des modèles
Future<void> registerHiveAdapters() async {
  print('🔄 Enregistrement des adaptateurs Hive...');
  
  try {
    // Modèles de base
    Hive.registerAdapter(UtilisateurAdapter());
    Hive.registerAdapter(EtudiantAdapter());
    Hive.registerAdapter(VigileAdapter());
    
    // Modèles liés aux cours et absences
    Hive.registerAdapter(AbsenceAdapter());
    Hive.registerAdapter(CoursAdapter());
    
    // Modèles liés aux justifications
    Hive.registerAdapter(StatutJustificationAdapter());
    Hive.registerAdapter(JustificationAdapter());
    
    // Modèles liés aux pointages
    Hive.registerAdapter(PointageAdapter());
    Hive.registerAdapter(PointageResultAdapter());
    Hive.registerAdapter(HistoriqueVigileResponseAdapter());
    
    print('✅ Tous les adaptateurs Hive ont été enregistrés avec succès');
  } catch (e) {
    print('❌ Erreur lors de l\'enregistrement des adaptateurs Hive: $e');
    // Vous pouvez décider de relancer l'exception ou de la gérer ici
    // throw e;
  }
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
