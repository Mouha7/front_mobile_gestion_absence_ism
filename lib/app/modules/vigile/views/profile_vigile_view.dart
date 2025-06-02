import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../modules/shared/profile_screen.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';

class VigileProfileView extends GetView<AuthController> {
  const VigileProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Essayer de charger les données utilisateur si elles sont manquantes
    if (controller.userData.value == null) {
      controller.loadUserData();
    }

    return Obx(() {
      final userData = controller.userData.value;
      print('🔍 VigileProfileView - userData: ${controller.userData}');

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
        role: 'Vigile',
        onLogout: controller.logout,
        isLoading: false,
      );
    });
  }
}
