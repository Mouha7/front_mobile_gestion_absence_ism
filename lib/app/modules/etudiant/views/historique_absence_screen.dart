import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/utils/helpers/date_formatter.dart';
import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:front_mobile_gestion_absence_ism/app/data/services/supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class EtudiantAbsencesView extends GetView<EtudiantController> {
  // Utiliser EtudiantController au lieu de HistoriqueController
  const EtudiantAbsencesView({super.key});

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Historique des absences',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => TextField(
                onChanged: (value) {
                  // Appeler la méthode de recherche quand le texte change
                  controller.searchAbsences(value);
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  // Supprimer tous les bordures et décorations non désirées
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // Ajouter un préfixe d'icône pour montrer que le filtrage est actif
                  prefixIcon:
                      controller.isDateFilterActive.value
                          ? const Icon(
                            Icons.filter_list,
                            color: AppTheme.primaryColor,
                          )
                          : null,
                ),
                cursorColor: AppTheme.primaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // La fonction sera exécutée lors du clic sur l'icône
              FocusScope.of(Get.context!).unfocus(); // Cache le clavier
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.brown[800],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filtrer par :',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            // Bouton pour filtrer par date
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppTheme.primaryColor,
                          ),
                          dialogTheme: DialogThemeData(
                            backgroundColor: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    controller.filterByDate(pickedDate);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Date',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Affichage du filtre actif
            Obx(
              () =>
                  controller.isDateFilterActive.value
                      ? Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${controller.selectedDate.value!.day.toString().padLeft(2, '0')}/${controller.selectedDate.value!.month.toString().padLeft(2, '0')}/${controller.selectedDate.value!.year}',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => controller.resetDateFilter(),
                              child: Icon(
                                Icons.close,
                                color: AppTheme.primaryColor,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAbsencesList(List<Map<String, dynamic>> absences) {
    // Si la liste est vide, afficher un message approprié
    if (absences.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 32),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.history_toggle_off,
                size: 60,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune absence ou retard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Votre historique est vide pour le moment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    print("historique --> $absences");

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: absences.length,
        itemBuilder: (context, index) {
          final absence = absences[index];

          // Déterminer le type d'absence et ses attributs visuels
          Color cardBorderColor;
          Color badgeColor;
          IconData statusIcon;
          String statusText;

          if (absence['type'] == "RETARD") {
            cardBorderColor = AppTheme.secondaryColor;
            badgeColor = Colors.amber.shade300;
            statusIcon = Icons.watch_later_outlined;
            statusText = "Retard ${absence['duree']}";
          } else {
            // Type ABSENCE_COMPLETE ou autre
            cardBorderColor = AppTheme.secondaryColor;
            badgeColor = Colors.red.shade300;
            statusIcon = Icons.person_off_outlined;
            statusText = "Absence";
          }

          final bool estJustifiee = absence['justification'] == true;

          return InkWell(
            onTap: () {
              // Afficher les détails de l'absence
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
                          absence['type'] == 'RETARD'
                              ? 'Détails du retard'
                              : 'Détails de l\'absence',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          'Matière',
                          absence['nomCours'] ?? 'Non spécifiée',
                        ),
                        _buildDetailRow(
                          'Date',
                          DateFormatter.formatDate(absence['date']),
                        ),
                        _buildDetailRow(
                          'Durée',
                          absence['duree'] ?? 'Non spécifiée',
                        ),
                        _buildDetailRow(
                          'Professeur',
                          absence['professeur'] ?? 'Non spécifié',
                        ),
                        _buildDetailRow(
                          'Salle',
                          absence['salle'] ?? 'Non spécifiée',
                        ),
                        _buildDetailRow(
                          'Heure de début',
                          DateFormatter.formatTime(absence['heureDebut']),
                        ),
                        _buildDetailRow(
                          'Heure d\'arrivée',
                          DateFormatter.formatTime(absence['heurePointage']),
                        ),
                        _buildDetailRow(
                          'État',
                          absence['etat'] ?? 'Non justifiée',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!estJustifiee)
                              TextButton.icon(
                                icon: const Icon(Icons.assignment_outlined),
                                label: const Text('Justifier'),
                                onPressed: () {
                                  Get.back(); // Fermer le dialogue
                                  // Ouvrir l'écran de justification avec les données de l'absence
                                  Get.toNamed(
                                    '/etudiant/justification/form',
                                    arguments: {
                                      'id': absence['id'],
                                      'matiere': absence['nomCours'],
                                      'date': DateFormatter.formatDate(
                                        absence['date'],
                                      ),
                                      'duree': absence['duree'],
                                      'professeur': absence['professeur'],
                                      'type':
                                          absence['type'] == 'RETARD'
                                              ? 'Retard'
                                              : 'Absence',
                                    },
                                  )?.then((result) {
                                    if (result == true) {
                                      // Rafraîchir les données après soumission de justification
                                      controller.refreshData();
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.primaryColor,
                                ),
                              ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Fermer'),
                              ),
                            ),
                          ],
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
                side: BorderSide(
                  color: cardBorderColor.withOpacity(0.5),
                  width: 1.5,
                ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
                              Icon(
                                statusIcon,
                                color: cardBorderColor,
                                size: 16,
                              ),
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
                                DateFormatter.formatTime(
                                  absence['heurePointage'] ?? '',
                                ),
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
                                absence['nomCours'] ?? 'Matière inconnue',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Indicateur de justification
                            Icon(
                              absence['isJustification'] == true
                                  ? Icons.check_circle_outline
                                  : Icons.info_outline,
                              size: 18,
                              color:
                                  absence['isJustification'] == true
                                      ? Colors.green
                                      : Colors.grey,
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
                                      absence['professeur'] ?? 'Non spécifié',
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

                            // Date du pointage (nouvelle position)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                DateFormatter.formatDate(absence['date'] ?? ''),
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
                                  absence['salle'] ?? 'Non spécifiée',
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

                  // Bouton pour justifier une absence
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: TextButton.icon(
                      icon: Icon(
                        estJustifiee
                            ? Icons.visibility_outlined
                            : Icons.assignment_outlined,
                        size: 16,
                      ),
                      label: Text(
                        estJustifiee
                            ? 'Voir détail'
                            : 'Justifier cette absence',
                      ),
                      onPressed: () {
                        if (estJustifiee) {
                          // Afficher les détails de la justification
                          _afficherDetailsJustification(context, absence);
                        } else {
                          // Naviguer vers le formulaire de justification
                          Get.toNamed(
                            '/etudiant/justification/form',
                            arguments: {
                              'id': absence['id'],
                              'matiere': absence['nomCours'],
                              'date': DateFormatter.formatDate(absence['date']),
                              'duree': absence['duree'],
                              'professeur': absence['professeur'],
                              'type':
                                  absence['type'] == 'RETARD'
                                      ? 'Retard'
                                      : 'Absence',
                            },
                          )?.then((result) {
                            if (result == true) {
                              // Rafraîchir les données après soumission de justification
                              controller.refreshData();
                            }
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: _buildAppBar(context) as PreferredSizeWidget?,
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  _buildFilterSection(),
                  controller.isLoading.value
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                      : _buildAbsencesList(controller.filteredAbsences),
                ],
              ),
            ),
          ),
        );
      }),
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

  void _afficherDetailsJustification(
    BuildContext context,
    Map<String, dynamic> absence,
  ) {
    Get.dialog(
      Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre avec statut
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Détails de la justification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatutColor(
                          absence['statutJustification'] ?? 'EN_ATTENTE',
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatStatut(
                          absence['statutJustification'] ?? 'EN_ATTENTE',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _getStatutColor(
                            absence['statutJustification'] ?? 'EN_ATTENTE',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Information sur l'absence
                _buildDetailRow(
                  'Matière',
                  absence['nomCours'] ?? 'Non spécifiée',
                ),
                _buildDetailRow(
                  'Date',
                  DateFormatter.formatDate(absence['date']),
                ),
                _buildDetailRow(
                  'Type',
                  absence['type'] == 'RETARD' ? 'Retard' : 'Absence',
                ),
                if (absence['type'] == 'RETARD')
                  _buildDetailRow(
                    'Durée du retard',
                    '${absence['minutesRetard'] ?? 0} minutes',
                  ),

                // Description de la justification
                const SizedBox(height: 12),
                const Text(
                  'Motif de justification',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  width: double.infinity,
                  child: Text(
                    absence['descriptionJustification'] ?? 'Aucun motif fourni',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                // Pièces jointes
                if (absence['piecesJointes'] != null &&
                    (absence['piecesJointes'] as List).isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Pièces justificatives',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  ...(absence['piecesJointes'] as List)
                      .map(
                        (piece) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () => _visualiserPieceJointe(piece),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.insert_drive_file,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        Uri.parse(piece).pathSegments.last,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.visibility,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],

                // Informations sur la validation
                const SizedBox(height: 16),
                _buildDetailRow(
                  'État actuel',
                  _formatStatut(absence['statutJustification'] ?? 'EN_ATTENTE'),
                ),

                // Date de validation si disponible
                if (absence['dateValidationJustification'] != null)
                  _buildDetailRow(
                    'Traité le',
                    DateFormatter.formatDate(
                      absence['dateValidationJustification'],
                    ),
                  ),

                // Bouton de fermeture
                const SizedBox(height: 20),
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
      ),
    );
  }

  // Méthode pour formater le statut de justification
  String _formatStatut(String statut) {
    switch (statut.toUpperCase()) {
      case 'EN_ATTENTE':
        return 'En attente';
      case 'VALIDEE':
        return 'Validée';
      case 'REJETEE':
        return 'Rejetée';
      default:
        return 'En attente';
    }
  }

  // Méthode pour obtenir la couleur selon le statut
  Color _getStatutColor(String statut) {
    switch (statut.toUpperCase()) {
      case 'EN_ATTENTE':
        return Colors.orange;
      case 'VALIDEE':
        return Colors.green;
      case 'REJETEE':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  // Méthode pour visualiser une pièce jointe
  void _visualiserPieceJointe(String url) async {
    // Afficher un indicateur de chargement
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      ),
      barrierDismissible: false,
    );

    try {
      final supabaseService = Get.find<SupabaseStorageService>();

      // Obtenir une URL signée pour l'accès au fichier
      final signedUrl = await supabaseService.getPublicUrl(url);

      // Vérifier si c'est un format d'image
      bool isImage =
          url.toLowerCase().endsWith('.jpg') ||
          url.toLowerCase().endsWith('.jpeg') ||
          url.toLowerCase().endsWith('.png') ||
          url.toLowerCase().endsWith('.gif');

      if (isImage) {
        // Fermer le dialogue de chargement
        Get.back();

        // Afficher l'image dans une lightbox
        Get.dialog(
          Dialog.fullscreen(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: AppTheme.primaryColor,
                  title: const Text('Pièce justificative', style: TextStyle(color: Colors.white)),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.white),
                      tooltip: 'Télécharger',
                      onPressed: () => _telechargerPieceJointe(url),
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_in_new, color: Colors.white),
                      tooltip: 'Ouvrir dans le navigateur',
                      onPressed: () => _ouvrirLienExterne(signedUrl),
                    ),
                  ],
                ),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Image.network(
                      signedUrl, // Utiliser l'URL signée ici
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Erreur de chargement d\'image: $error');
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Impossible de charger l\'image',
                                style: TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                error.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Pour les documents PDF, XLSX, DOC, etc.
        Get.back(); // Fermer le dialogue de chargement

        // Afficher une boîte de dialogue avec des options pour le fichier
        Get.dialog(
          Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Fichier: ${Uri.parse(url).pathSegments.last}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFileTypeIcon(url),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _telechargerPieceJointe(url),
                        icon: const Icon(Icons.download),
                        label: const Text('Télécharger'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          _ouvrirLienExterne(signedUrl);
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Ouvrir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } catch (e) {
      Get.back(); // Fermer le dialogue de chargement en cas d'erreur
      Get.snackbar(
        'Erreur',
        'Impossible de charger la pièce jointe: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      print('Erreur lors du chargement de la pièce jointe: $e');
    }
  }

  // Méthode pour télécharger une pièce jointe
  void _telechargerPieceJointe(String url) async {
    try {
      final supabaseService = Get.find<SupabaseStorageService>();
      final tempFilePath = await supabaseService.downloadFile(url);

      if (tempFilePath != null) {
        Get.snackbar(
          'Téléchargement réussi',
          'Le fichier a été téléchargé',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Ouvrir le fichier avec l'application par défaut
        final fileUri = Uri.parse('file://$tempFilePath');
        if (await canLaunchUrl(fileUri)) {
          await launchUrl(fileUri);
        }
      } else {
        Get.snackbar(
          'Erreur',
          'Le téléchargement a échoué',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de télécharger le fichier: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Méthode pour ouvrir un lien externe
  void _ouvrirLienExterne(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible d\'ouvrir le fichier',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildFileTypeIcon(String url) {
    // Déterminer l'icône à afficher en fonction de l'extension du fichier
    String extension = url.split('.').last.toLowerCase();

    IconData iconData;
    Color iconColor;

    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.document_scanner;
        iconColor = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'ppt':
      case 'pptx':
        iconData = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case 'txt':
        iconData = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        // Pour les images, utiliser une icône d'image par défaut
        iconData = Icons.image;
        iconColor = Colors.purple;
        break;
      default:
        // Pour les fichiers inconnus, utiliser une icône de fichier générique
        iconData = Icons.insert_drive_file;
        iconColor = Colors.black54;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, size: 40, color: iconColor),
    );
  }
}
