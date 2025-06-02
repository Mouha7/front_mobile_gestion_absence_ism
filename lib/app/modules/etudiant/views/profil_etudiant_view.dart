import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/auth_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/shared/profile_screen.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';

class ProfilEtudiantView extends GetView<AuthController> {
  const ProfilEtudiantView({super.key});

  @override
  Widget build(BuildContext context) {
    // Essayer de charger les données utilisateur si elles sont manquantes
    if (controller.userData.value == null) {
      controller.loadUserData();
    }

    return Obx(() {
      final userData = controller.userData.value;
      print('🔍 ProfilEtudiantView - userData: ${controller.userData}');

      if (userData == null) {
        return Scaffold(
          backgroundColor: AppTheme.primaryColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Chargement du profil...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }

      return ProfilMenu(
        nom: userData['nom'] ?? '',
        prenom: userData['prenom'] ?? '',
        email: userData['email'] ?? '',
        role: 'Étudiant',
        onLogout: controller.logout,
        isLoading: false,
      );
    });
  }
}
