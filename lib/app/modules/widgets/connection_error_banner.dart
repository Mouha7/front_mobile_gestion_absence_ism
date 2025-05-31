import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionErrorBanner extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;
  final bool isDismissible;

  const ConnectionErrorBanner({
    super.key,
    required this.onRetry,
    this.message =
        'Impossible de se connecter au serveur. Vérifiez que le serveur JSON est bien lancé.',
    this.isDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(color: Colors.red),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Problème de connexion',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Réessayer',
          ),
          if (isDismissible)
            IconButton(
              onPressed: () {
                // Remove the banner if it's dismissible
                Get.delete<ConnectionErrorController>();
              },
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Fermer',
            ),
        ],
      ),
    );
  }
}

/// Controller pour gérer l'état de la bannière d'erreur
class ConnectionErrorController extends GetxController {
  final RxBool isVisible = true.obs;
  final RxString message =
      'Impossible de se connecter au serveur. Vérifiez que le serveur JSON est bien lancé.'
          .obs;

  void setMessage(String newMessage) {
    message.value = newMessage;
  }

  void show() {
    isVisible.value = true;
  }

  void hide() {
    isVisible.value = false;
  }

  void retry(VoidCallback retryAction) {
    retryAction();
  }
}