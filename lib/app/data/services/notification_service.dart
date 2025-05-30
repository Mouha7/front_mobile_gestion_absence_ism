import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  // Afficher une notification de succès
  void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  // Afficher une notification d'erreur
  void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );
  }

  // Afficher une notification d'information
  void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.withOpacity(0.7),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }
}
