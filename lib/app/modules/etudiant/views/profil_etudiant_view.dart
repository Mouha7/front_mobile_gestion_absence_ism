import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/auth_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/shared/profile_screen.dart';
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
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
