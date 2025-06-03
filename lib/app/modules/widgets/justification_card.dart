import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';
import 'dart:io';

class JustificationCard extends StatelessWidget {
  final Map<String, dynamic> absenceData;
  final bool isEditable;
  final Color cardBorderColor;
  final Color badgeColor;
  final IconData statusIcon;
  final String statusText;
  final Function()? onAddJustification;
  final Function()? onViewDetails;

  const JustificationCard({
    super.key,
    required this.absenceData,
    this.isEditable = false,
    this.cardBorderColor = const Color(0xFF5C6BC0), // Couleur par défaut
    this.badgeColor = const Color(0xFFE3F2FD), // Couleur par défaut
    this.statusIcon = Icons.info_outline, // Icône par défaut
    this.statusText = "Absence", // Texte par défaut
    this.onAddJustification,
    this.onViewDetails,
  });

  bool get hasJustification =>
      absenceData['justification'] != null &&
      absenceData['justification'].toString().isNotEmpty;

  String get justificationStatus {
    if (!hasJustification) return 'Non justifiée';

    final status = absenceData['justificationStatus']?.toString() ?? 'pending';
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approuvée';
      case 'rejected':
        return 'Rejetée';
      case 'pending':
      default:
        return 'En attente';
    }
  }

  Color get statusColor {
    if (!hasJustification) return Colors.red;

    final status = absenceData['justificationStatus']?.toString() ?? 'pending';
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  Widget _buildAttachmentPreview() {
    final attachmentPath = absenceData['attachmentPath']?.toString();
    if (attachmentPath == null || attachmentPath.isEmpty) {
      return Container();
    }

    // Vérifier si c'est une URL (commence par http ou https)
    final isUrl =
        attachmentPath.startsWith('http://') ||
        attachmentPath.startsWith('https://');

    // Vérifier l'extension du fichier
    final isImage =
        attachmentPath.toLowerCase().endsWith('.jpg') ||
        attachmentPath.toLowerCase().endsWith('.jpeg') ||
        attachmentPath.toLowerCase().endsWith('.png');

    // Si c'est une image, l'afficher
    if (isImage) {
      return InkWell(
        onTap: () {
          // Action pour ouvrir l'image en plein écran ou dans une visionneuse
          Get.dialog(
            Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  InteractiveViewer(
                    child:
                        isUrl
                            ? Image.network(
                              attachmentPath,
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (context, error, stackTrace) => const Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                  ),
                            )
                            : Image.file(
                              File(attachmentPath),
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (context, error, stackTrace) => const Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                  ),
                            ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    isUrl
                        ? Image.network(
                          attachmentPath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        )
                        : Image.file(
                          File(attachmentPath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        ),
              ),
              Container(
                color: Colors.black.withOpacity(0.2),
                width: double.infinity,
                height: double.infinity,
              ),
              const Icon(Icons.zoom_in, color: Colors.white, size: 36),
            ],
          ),
        ),
      );
    }

    // Pour les autres types de fichiers (PDF, DOC, etc.)
    return InkWell(
      onTap: () {
        // Action pour ouvrir le document
        Get.snackbar(
          'Document',
          'Ouverture du document: ${attachmentPath.split('/').last}',
          snackPosition: SnackPosition.TOP,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getFileIcon(attachmentPath),
                color: AppTheme.primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachmentPath.split('/').last,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cliquer pour ouvrir',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new, color: AppTheme.primaryColor, size: 20),
          ],
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // En-tête avec détails de l'absence
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône de la matière
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFF452917),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(width: 12),
                // Informations de l'absence
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        absenceData['matiere'] ?? 'Matière inconnue',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${absenceData['date'] ?? 'Date inconnue'} - ${absenceData['duree'] ?? 'Durée inconnue'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            absenceData['professeur'] ?? 'Prof inconnu',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Flèche pour détails
                if (onViewDetails != null)
                  InkWell(
                    onTap: onViewDetails,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Ligne de séparation
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),

          // Section de statut et action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicateur de statut
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasJustification ? Icons.check_circle : Icons.cancel,
                        color: statusColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        justificationStatus,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bouton d'action
                if (isEditable && !hasJustification)
                  ElevatedButton.icon(
                    onPressed: onAddJustification,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Justifier'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
              ],
            ),
          ),

          // Afficher la justification si elle existe
          if (hasJustification)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Séparateur pour la section de justification
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  const SizedBox(height: 12),

                  // Titre de justification
                  const Text(
                    'Justification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Contenu de la justification
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      absenceData['justification'] ?? '',
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                    ),
                  ),

                  // Pièce jointe si disponible
                  if (absenceData['attachmentPath'] != null &&
                      absenceData['attachmentPath'].toString().isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Pièce jointe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: _buildAttachmentPreview(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
