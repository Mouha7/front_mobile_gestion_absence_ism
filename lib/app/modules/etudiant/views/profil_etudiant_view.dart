import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/auth_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/shared/profile_screen.dart';
import 'package:get/get.dart';

class ProfilEtudiantView extends GetView<EtudiantController> {
  final AuthController authController = Get.find<AuthController>();

  ProfilEtudiantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userData = authController.userData.value;

      if (userData == null) {
        return const Scaffold(
          // backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return ProfilMenu(
        nom: userData['nom'] ?? '',
        prenom: userData['prenom'] ?? '',
        email: userData['email'] ?? '',
        role: 'Étudiant',
        onLogout: authController.logout,
        // isLoading: false,
        isLoading: controller.isLoading.value,
      );
    });
  }
}
