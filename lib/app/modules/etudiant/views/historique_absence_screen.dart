import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/app/utils/helpers/date_formatter.dart';
import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart'; // Changé pour utiliser etudiant_controller

class EtudiantAbsencesView extends GetView<EtudiantController> { // Utiliser EtudiantController au lieu de HistoriqueController
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
                          ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
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
            Obx(() => controller.isDateFilterActive.value
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
              : const SizedBox.shrink()),
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
              const Icon(Icons.history_toggle_off, size: 60, color: Colors.grey),
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
            cardBorderColor = Colors.red;
            badgeColor = Colors.red.shade300;
            statusIcon = Icons.person_off_outlined;
            statusText = "Absence";
          }
          
          final bool peutJustifier = absence['justification'] != true; // N'afficher le bouton que si l'absence n'est pas déjà justifiée
          
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
                          absence['type'] == 'RETARD' ? 'Détails du retard' : 'Détails de l\'absence',
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
                            if (peutJustifier)
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
                                      'date': DateFormatter.formatDate(absence['date']),
                                      'duree': absence['duree'],
                                      'professeur': absence['professeur'],
                                      'type': absence['type'] == 'RETARD' ? 'Retard' : 'Absence',
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
                                DateFormatter.formatTime(absence['heurePointage'] ?? ''),
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
                              absence['justification'] == true
                                  ? Icons.check_circle_outline
                                  : Icons.info_outline,
                              size: 18,
                              color: absence['justification'] == true
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
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  if (peutJustifier)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: TextButton.icon(
                        icon: const Icon(Icons.assignment_outlined, size: 16),
                        label: const Text('Justifier cette absence'),
                        onPressed: () {
                          // Naviguer vers le formulaire de justification
                          Get.toNamed(
                            '/etudiant/justification/form',
                            arguments: {
                              'id': absence['id'],
                              'matiere': absence['nomCours'],
                              'date': DateFormatter.formatDate(absence['date']),
                              'duree': absence['duree'],
                              'professeur': absence['professeur'],
                              'type': absence['type'] == 'RETARD' ? 'Retard' : 'Absence',
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
}
