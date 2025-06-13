import 'package:front_mobile_gestion_absence_ism/app/data/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> pulseAnimation;

  @override
  void onInit() {
    super.onInit();

    // Initialiser le contrôleur d'animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Durée de chaque battement
    );

    // Créer une séquence d'animation pour l'effet de battement
    pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15), // Gonflement
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.95), // Dégonflement rapide
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.05), // Rebond léger
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 1.0,
        ), // Retour à la taille normale
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Lancer l'animation avec répétition
    animationController.repeat();

    // Navigation automatique après un délai
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Attendre 3 secondes avant de naviguer vers l'écran suivant
    await Future.delayed(const Duration(seconds: 3));

    // Obtenir le contrôleur d'authentification
    final storageService = Get.find<StorageService>();

    final userRole = storageService.getUser();
    if (userRole != null) {
      if (userRole['role'] == 'ETUDIANT') {
        Get.offAllNamed(Routes.ETUDIANT_DASHBOARD);
      } else if (userRole['role'] == 'VIGILE') {
        Get.offAllNamed(Routes.VIGILE_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
