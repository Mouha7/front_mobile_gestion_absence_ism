import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';

class ServerConfigViewNew extends GetView<EtudiantController> {
  const ServerConfigViewNew({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = Get.find<ApiService>();
    final TextEditingController serverUrlController = TextEditingController(
      text: apiService.baseUrl,
    );

    // Variables réactives pour l'état de la connexion et la recherche
    final RxBool isTestingConnection = false.obs;
    final RxBool connectionSuccess = false.obs;
    final RxBool isSearchingNetworkIps = false.obs;
    final RxList<String> discoveredIps = <String>[].obs;

    // Fonction pour rechercher des adresses IP sur le réseau local
    Future<void> searchNetworkIps() async {
      isSearchingNetworkIps.value = true;
      discoveredIps.clear();

      try {
        Get.snackbar(
          'Recherche en cours',
          'Recherche d\'adresses IP sur le réseau local...',
          backgroundColor: Colors.blue.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );

        // Simulons une recherche d'adresses IP (dans une application réelle, nous utiliserions
        // un package comme network_info_plus ou connectivity_plus pour scanner le réseau)
        await Future.delayed(Duration(seconds: 2));

        // Générer quelques adresses IP de test basées sur l'adresse IP actuelle
        // Dans une application réelle, ces adresses seraient détectées par un scan réseau
        final String baseIp = '192.168.1';
        for (int i = 1; i <= 10; i++) {
          discoveredIps.add('$baseIp.$i');
        }

        Get.snackbar(
          'Recherche terminée',
          '${discoveredIps.length} adresses IP trouvées',
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } catch (e) {
        Get.snackbar(
          'Erreur',
          'Impossible de rechercher des adresses IP: $e',
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isSearchingNetworkIps.value = false;
      }
    }

    // Fonction pour tester la connexion avec l'URL actuelle
    Future<void> testConnection(String url) async {
      final ApiService apiService = Get.find<ApiService>();
      final RxBool isTestingConnection = false.obs;

      isTestingConnection.value = true;

      try {
        apiService.setBaseUrl(url);
        final bool success = await apiService.testConnection();

        Get.snackbar(
          success ? 'Connexion réussie' : 'Échec de connexion',
          success
              ? 'Le serveur est accessible à l\'adresse $url'
              : 'Impossible de se connecter au serveur à l\'adresse $url',
          backgroundColor:
              success
                  ? Colors.green.withOpacity(0.7)
                  : Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      } catch (e) {
        Get.snackbar(
          'Erreur',
          'Une erreur s\'est produite: $e',
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isTestingConnection.value = false;
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: Text('Configuration du serveur'),
        backgroundColor: AppTheme.secondaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adresse du serveur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: serverUrlController,
                decoration: InputDecoration(
                  hintText: 'http://192.168.1.100:3000',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Bouton de test de connexion
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ElevatedButton.icon(
                        onPressed:
                            isTestingConnection.value
                                ? null
                                : () =>
                                    testConnection(serverUrlController.text),
                        icon:
                            isTestingConnection.value
                                ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.black54,
                                    strokeWidth: 3,
                                  ),
                                )
                                : Icon(Icons.wifi_tethering),
                        label: Text(
                          isTestingConnection.value
                              ? 'Test en cours...'
                              : 'Tester la connexion',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Bouton pour rechercher les adresses IP du réseau
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          isSearchingNetworkIps.value
                              ? null
                              : () => searchNetworkIps(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child:
                          isSearchingNetworkIps.value
                              ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                              : Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Paramètres prédéfinis:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),

            // Options prédéfinies en fonction de la plateforme
            _buildPlatformSpecificOptions(serverUrlController),

            // Affichage des adresses IP découvertes
            Obx(() {
              if (discoveredIps.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Adresses IP détectées:',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: discoveredIps.length,
                        itemBuilder: (context, index) {
                          final ip = discoveredIps[index];
                          return ListTile(
                            dense: true,
                            title: Text(
                              ip,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                serverUrlController.text = 'http://$ip:3000';
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text('Utiliser'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),

            Spacer(),

            // Bouton d'enregistrement
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (serverUrlController.text.isNotEmpty) {
                    controller.setServerUrl(serverUrlController.text);
                    Get.back();
                    Get.snackbar(
                      'Configuration',
                      'Connexion au serveur: ${serverUrlController.text}',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Enregistrer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSpecificOptions(TextEditingController controller) {
    return Column(
      children: [
        if (Platform.isAndroid) ...[
          _buildServerOption(
            'Émulateur Android',
            'http://10.0.2.2:3000',
            controller,
            icon: Icons.android,
          ),
          _buildServerOption(
            'Appareil Android',
            'http://192.168.1.100:3000',
            controller,
            icon: Icons.android,
            subtitle: 'Remplacez par l\'adresse IP de votre ordinateur',
          ),
        ],
        if (Platform.isIOS) ...[
          _buildServerOption(
            'Simulateur iOS',
            'http://localhost:3000',
            controller,
            icon: Icons.phone_iphone,
          ),
          _buildServerOption(
            'Appareil iOS Physique',
            'http://192.168.1.100:3000',
            controller,
            icon: Icons.phone_iphone,
            subtitle: 'Remplacez par l\'adresse IP de votre ordinateur',
          ),
        ],
        _buildServerOption(
          'Ordinateur local',
          'http://localhost:3000',
          controller,
          icon: Icons.computer,
        ),
        _buildServerOption(
          'WiFi (à configurer)',
          'http://192.168.1.100:3000',
          controller,
          icon: Icons.wifi,
          subtitle: 'Remplacez par l\'adresse IP de votre réseau local',
        ),
      ],
    );
  }

  Widget _buildServerOption(
    String label,
    String url,
    TextEditingController controller, {
    IconData? icon,
    String? subtitle,
  }) {
    return InkWell(
      onTap: () {
        controller.text = url;
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white70),
              SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle ?? url,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
          ],
        ),
      ),
    );
  }
}
