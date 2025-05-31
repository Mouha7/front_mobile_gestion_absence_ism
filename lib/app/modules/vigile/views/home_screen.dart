import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:front_mobile_gestion_absence_ism/app/controllers/vigile_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../utils/scanner_overlay.dart';
import '../../widgets/navigation_menu.dart';

class VigileHomeScreen extends GetView<VigileController> {
  const VigileHomeScreen({super.key});

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
        onPressed: () {
          // Utiliser Get.toNamed pour une navigation plus fiable
          Get.toNamed(Routes.VIGILE_PROFILE);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      automaticallyImplyLeading: false,
    );
  }

  void _startScanning() {
    if (kIsWeb) {
      Get.dialog(
        AlertDialog(
          title: const Text('Scanner QR'),
          content: const Text('Scanner un code QR'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                controller.traiterCodeQR('ETUDIANT-123456');
              },
              child: const Text('Simuler un scan'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Annuler'),
            ),
          ],
        ),
      );
      return;
    }

    final scannerController = MobileScannerController();

    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Scanner QR Code',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF4E2A16),
          elevation: 0,
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: scannerController,
              onDetect: (capture) async {
                if (controller.isScanning.value) return;

                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null) {
                    scannerController.stop();
                    Get.back();
                    await controller.traiterCodeQR(code);
                  }
                }
              },
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              child: CustomPaint(
                painter: ScannerOverlay(
                  borderColor: const Color(0xFF4E2A16),
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
                child: Container(),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 150,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4E2A16),
                    borderRadius: BorderRadius.circular(22.5),
                  ),
                  child: TextButton(
                    onPressed: () {
                      scannerController.stop();
                      Get.back();
                    },
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationScreen() {
    return Positioned.fill(
      child: Container(
        color: const Color(0xFF1F1F1F),
        child: Obx(() {
          final isSuccess = controller.validationSuccess.value;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSuccess ? const Color(0xFF4CAF50) : Colors.red,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check : Icons.close,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "${controller.etudiantScanne.value!.nom} ${controller.etudiantScanne.value!.prenom}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  isSuccess ? 'Accès autorisé' : 'Accès refusé',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.etudiantScanne.value!.matricule,
                  style: const TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  "Niveau: ${controller.etudiantScanne.value!.niveau} - Filière: ${controller.etudiantScanne.value!.filiere}",
                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: _buildAppBar() as PreferredSizeWidget?,
      body: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 50, left: 16, right: 16),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.matriculeController,
                          decoration: InputDecoration(
                            hintText: 'Matricule',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted:
                              (value) => controller.verifierMatricule(value),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-2, 0),
                        child: GestureDetector(
                          onTap:
                              () => controller.verifierMatricule(
                                controller.matriculeController.text,
                              ),
                          child: Container(
                            height: 40,
                            width: 140,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4E2A16),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Valider',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(0.5), thickness: 1),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Obx(
                        () =>
                            controller.etudiantScanne.value == null
                                ? GestureDetector(
                                  onTap: _startScanning,
                                  child: Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD2B48C),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'ISM',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Appuyez pour scanner',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Color(0xFF8B4513),
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      '${controller.etudiantScanne.value!.nom} ${controller.etudiantScanne.value!.prenom}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEEEEE),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        controller
                                            .etudiantScanne
                                            .value!
                                            .matricule,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Module: ${controller.etudiantScanne.value!.filiere}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Niveau: ${controller.etudiantScanne.value!.niveau}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Scanner le QR pour vérifier l\'identité',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                NavigationMenu(
                  activeTab: 'scanner'.obs,
                  onScannerTap: _startScanning,
                  onHistoriqueTap: () => Get.toNamed(Routes.VIGILE_HISTORIQUE),
                ),
              ],
            ),
            Obx(() {
              if (controller.validationVisible.value) {
                return _buildValidationScreen();
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
