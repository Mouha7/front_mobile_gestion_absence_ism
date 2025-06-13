import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assurez-vous que le contrôleur est injecté
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo avec animation de pulsation
            AnimatedBuilder(
              animation: controller.pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: controller.pulseAnimation.value,
                  child: child,
                );
              },
              child: Image.asset('assets/images/logo_ism.png', height: 300),
            ),

            const SizedBox(height: 40),

            // Indicateur de chargement
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),

            const SizedBox(height: 20),

            // Message discret
            const Text(
              'Chargement...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
