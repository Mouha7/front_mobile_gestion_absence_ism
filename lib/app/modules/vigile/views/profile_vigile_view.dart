import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../modules/shared/profile_screen.dart';

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
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
