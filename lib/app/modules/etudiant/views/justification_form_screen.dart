import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'dart:io';
import 'package:front_mobile_gestion_absence_ism/app/controllers/justification_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:front_mobile_gestion_absence_ism/app/utils/helpers/snackbar_utils.dart';
import 'package:get/get.dart';

class JustificationFormView extends GetView<JustificationController> {
  const JustificationFormView({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer les données d'absence passées en paramètre
    final Map<String, dynamic> absenceData = Get.arguments ?? {};

    // Initialiser l'ID de l'absence si disponible
    if (absenceData['id'] != null) {
      controller.absenceId.value = absenceData['id'].toString();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Soumettre une justification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(
        () => SafeArea(
          child: Column(
            children: [
              // Partie scrollable avec le formulaire
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Carte d'information sur l'absence
                      if (absenceData.isNotEmpty)
                        _buildAbsenceInfoCard(absenceData),

                      const SizedBox(height: 20),

                      // Section de description
                      const Text(
                        'Description de la justification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged:
                              (value) => controller.description.value = value,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Décrivez la raison de votre absence...",
                            contentPadding: EdgeInsets.all(16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Section de pièces jointes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pièces justificatives',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          // Nombre de pièces jointes
                          Obx(
                            () =>
                                controller.selectedFiles.isNotEmpty
                                    ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${controller.selectedFiles.length} pièce(s)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Liste des fichiers sélectionnés
                      Obx(() => _buildFilesPreview()),

                      const SizedBox(height: 16),

                      // Boutons pour choisir des fichiers
                      Row(
                        children: [
                          Expanded(
                            child: _buildPickButton(
                              icon: Icons.camera_alt,
                              label: "Prendre des photos",
                              onTap: controller.pickFromCamera,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPickButton(
                              icon: Icons.file_present,
                              label: "Choisir des documents",
                              onTap: controller.pickMultipleFromDevice,
                            ),
                          ),
                        ],
                      ),

                      // Espace supplémentaire pour le padding en bas
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              // Bouton d'envoi fixé en bas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed:
                      controller.description.value.isEmpty
                          ? null
                          : () => _submitJustification(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    disabledBackgroundColor: Colors.grey[400],
                  ),
                  child: const Text(
                    "Envoyer ma justification",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Indicateur de chargement en plein écran
      resizeToAvoidBottomInset: true,
      extendBody: false,
      extendBodyBehindAppBar: false,
      bottomNavigationBar:
          controller.isSubmitting.value
              ? Container(height: 0, color: Colors.transparent)
              : null,
    );
  }

  Widget _buildAbsenceInfoCard(Map<String, dynamic> absenceData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations sur l\'absence',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.menu_book,
            label: 'Matière',
            value: absenceData['matiere']?.toString() ?? 'Non spécifié',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: absenceData['date']?.toString() ?? 'Non spécifié',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Durée',
            value: absenceData['duree']?.toString() ?? 'Non spécifié',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.person,
            label: 'Professeur',
            value: absenceData['professeur']?.toString() ?? 'Non spécifié',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilesPreview() {
    if (controller.selectedFiles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.upload_file,
              size: 40,
              color: AppTheme.primaryColor.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aucun fichier sélectionné',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ajoutez des photos ou des documents',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Grille d'aperçus d'images
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemCount: controller.selectedFiles.length,
          itemBuilder: (context, index) {
            final file = controller.selectedFiles[index];
            final String fileName = file.path.split('/').last;
            final bool isImage =
                fileName.toLowerCase().endsWith('.jpg') ||
                fileName.toLowerCase().endsWith('.jpeg') ||
                fileName.toLowerCase().endsWith('.png');

            return _buildFilePreviewItem(file, isImage, index);
          },
        ),

        // Bouton pour ajouter plus de fichiers
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: InkWell(
            onTap: () => _showAddFileOptions(Get.context!),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ajouter un autre document',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePreviewItem(File file, bool isImage, int index) {
    final String fileName = file.path.split('/').last;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child:
                  isImage
                      ? Image.file(
                        file,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      )
                      : Container(
                        color: Colors.grey[50],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getFileIcon(fileName),
                                color: AppTheme.primaryColor,
                                size: 30,
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  fileName.length > 10
                                      ? '${fileName.substring(0, 7)}...'
                                      : fileName,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ),
          // Bouton de suppression
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () => controller.removeFile(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ajouter un document',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                _buildOptionTile(
                  icon: Icons.camera_alt,
                  title: 'Prendre une photo',
                  subtitle: 'Capturer une image avec l\'appareil photo',
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickFromCamera();
                  },
                ),
                const Divider(),
                _buildOptionTile(
                  icon: Icons.photo_library,
                  title: 'Choisir des images',
                  subtitle: 'Sélectionner depuis la galerie',
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImagesFromGallery();
                  },
                ),
                const Divider(),
                _buildOptionTile(
                  icon: Icons.file_present,
                  title: 'Choisir des documents',
                  subtitle: 'PDF, Word, Excel, etc.',
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickMultipleFromDevice();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  IconData _getFileIcon(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _submitJustification(BuildContext context) async {
    if (controller.description.value.isEmpty) {
      SnackbarUtils.showError(
        'Erreur',
        'Veuillez saisir une description pour votre justification',
      );
      return;
    }

    // Afficher un overlay de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => WillPopScope(
            onWillPop: () async => false,
            child: const Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
    );

    final success = await controller.envoyerJustification();

    // Fermer l'overlay de chargement
    Navigator.pop(context);

    if (success) {
      // Afficher un message de succès
      Get.snackbar(
        'Succès',
        'Votre justification a été envoyée avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      // Petit délai pour permettre à l'utilisateur de voir le message avant la navigation
      await Future.delayed(const Duration(milliseconds: 1000));

      // Retourner à l'écran d'historique des absences
      Get.offNamed(Routes.ETUDIANT_ABSENCES);

      // Rafraîchir les données de l'historique après la navigation
      final etudiantController = Get.find<EtudiantController>();
      await etudiantController.refreshData();
    } else {
      // Afficher un message d'erreur
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de l\'envoi de votre justification',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
