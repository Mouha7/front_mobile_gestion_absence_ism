import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';
import 'package:front_mobile_gestion_absence_ism/app/utils/helpers/date_formatter.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:get/get.dart';

class EtudiantDashboardView extends GetView<EtudiantController> {
  const EtudiantDashboardView({super.key});

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
        onPressed: () => Get.toNamed(Routes.ETUDIANT_PROFILE),
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

  Widget _buildQRCodeSection() {
    return Obx(() {
      if (controller.isServerConnected.value) {
        return Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: QrImageView(
                    data: controller.qrCodeData.value,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.black,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.badge_outlined, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        controller.qrCodeData.value.isNotEmpty
                            ? controller.qrCodeData.value
                            : 'Chargement...',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Afficher un message d'erreur de connexion simplifié
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(Icons.wifi_off, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erreur de connexion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Impossible de se connecter au serveur. Vérifiez que le serveur est démarré.',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                onPressed: () {
                  controller.refreshData();
                },
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _buildRetardsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '5 Derniers pointages',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.ETUDIANT_ABSENCES);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Voir historique',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildRetardsList(List<Map<String, dynamic>> pointages) {
    // Si la liste est vide, afficher un message approprié
    if (pointages.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Aucun pointage récent',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vos pointages récents s\'afficheront ici.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: pointages.length,
        itemBuilder: (context, index) {
          final pointage = pointages[index];
          
          // Déterminer le type de pointage et ses attributs visuels
          Color cardBorderColor;
          Color badgeColor;
          IconData statusIcon;
          String statusText;
          
          if (pointage['type'] == "PRESENT") {
            cardBorderColor = AppTheme.secondaryColor;
            badgeColor = Colors.green.shade300;
            statusIcon = Icons.check_circle_outline;
            statusText = "Présence";
          } else if (pointage['type'] == "RETARD") {
            cardBorderColor = AppTheme.secondaryColor;
            badgeColor = Colors.amber.shade300;
            statusIcon = Icons.watch_later_outlined;
            statusText = "Retard ${pointage['duree']}";
          } else {
            cardBorderColor = AppTheme.secondaryColor;
            badgeColor = Colors.red.shade300;
            statusIcon = Icons.person_off_outlined;
            statusText = "Absence";
          }
          
          return InkWell(
            onTap: () {
              // Afficher les détails du pointage
              Get.dialog(
                Dialog(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pointage['type'] == 'PRESENT' 
                              ? 'Détails de la présence'
                              : (pointage['type'] == 'RETARD'
                                  ? 'Détails du retard'
                                  : 'Détails de l\'absence'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          'Matière',
                          pointage['nomCours'] ?? 'Non spécifiée',
                        ),
                        _buildDetailRow(
                          'Date',
                          DateFormatter.formatDate(pointage['date']),
                        ),
                        if (pointage['type'] == 'RETARD')
                          _buildDetailRow(
                            'Durée',
                            pointage['duree'] ?? 'Non spécifiée',
                          ),
                        _buildDetailRow(
                          'Professeur',
                          pointage['professeur'] ?? 'Non spécifié',
                        ),
                        _buildDetailRow(
                          'Salle',
                          pointage['salle'] ?? 'Non spécifiée',
                        ),
                        _buildDetailRow(
                          'Heure de début',
                          DateFormatter.formatTime(pointage['heureDebut']),
                        ),
                        _buildDetailRow(
                          'Heure de pointage',
                          DateFormatter.formatTime(pointage['heurePointage']),
                        ),
                        if (pointage['type'] != 'PRESENT')
                          _buildDetailRow(
                            'État',
                            pointage['justification'] == true ? 'Justifié' : 'Non justifié',
                          ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Fermer'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: cardBorderColor.withOpacity(0.5), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête coloré
                  Container(
                    decoration: BoxDecoration(
                      color: cardBorderColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Badge de statut
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, color: cardBorderColor, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: cardBorderColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Heure du pointage
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormatter.formatTime(pointage['heurePointage'] ?? ''),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Contenu principal
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Matière
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book_outlined,
                              size: 18,
                              color: Colors.indigo,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                pointage['nomCours'] ?? 'Matière inconnue',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Indicateur que la carte est cliquable
                            const Icon(
                              Icons.info_outline,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Informations supplémentaires
                        Row(
                          children: [
                            // Professor
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      pointage['professeur'] ?? 'Non spécifié',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Date du pointage
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                DateFormatter.formatDate(pointage['date'] ?? ''),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            
                            // Salle
                            Row(
                              children: [
                                const Icon(
                                  Icons.room_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  pointage['salle'] ?? 'Non spécifiée',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: _buildAppBar() as PreferredSizeWidget?,
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Partie fixe (en-tête)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQRCodeSection(),
                  const SizedBox(height: 24),
                  _buildRetardsHeader(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            
            // Partie scrollable (liste des retards)
            Expanded(
              child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : _buildRetardsList(controller.retards),
            ),
          ],
        );
      }),
    );
  }
}
