import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';
import '../../../controllers/vigile_controller.dart';

class VigileHistoriqueView extends GetView<VigileController> {
  const VigileHistoriqueView({super.key});

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Historique des scans',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
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
                controller: controller.searchController,
                onChanged: (value) {
                  controller.searchHistorique(value);
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  prefixIcon:
                      controller.isDateFilterActive.value
                          ? Icon(
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
    return Obx(
      () => Row(
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
              // Afficher la date sélectionnée si le filtre est actif
              if (controller.isDateFilterActive.value)
                Container(
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
                ),
              // Bouton pour sélectionner une date
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate:
                        controller.selectedDate.value ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppTheme.primaryColor,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                            ),
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
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoriqueList(List<Map<String, dynamic>> historique) {
    // Si la liste est vide après une recherche ou un filtrage par date, afficher un message
    if (historique.isEmpty &&
        (controller.searchQuery.value.isNotEmpty ||
            controller.isDateFilterActive.value)) {
      String message = '';

      if (controller.searchQuery.value.isNotEmpty &&
          controller.isDateFilterActive.value) {
        // Si les deux filtres sont actifs
        message =
            'Aucun résultat trouvé pour "${controller.searchQuery.value}" à la date du ${controller.selectedDate.value!.day.toString().padLeft(2, '0')}/${controller.selectedDate.value!.month.toString().padLeft(2, '0')}/${controller.selectedDate.value!.year}';
      } else if (controller.searchQuery.value.isNotEmpty) {
        // Si seulement la recherche est active
        message =
            'Aucun résultat trouvé pour "${controller.searchQuery.value}"';
      } else if (controller.isDateFilterActive.value) {
        // Si seulement le filtre par date est actif
        message =
            'Aucun scan à la date du ${controller.selectedDate.value!.day.toString().padLeft(2, '0')}/${controller.selectedDate.value!.month.toString().padLeft(2, '0')}/${controller.selectedDate.value!.year}';
      }

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
              const Icon(Icons.search_off, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Essayez avec d\'autres critères de recherche',
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
        itemCount: historique.length,
        itemBuilder: (context, index) {
          final item = historique[index];
          return _buildHistoriqueCard(item);
        },
      ),
    );
  }

  Widget _buildHistoriqueCard(Map<String, dynamic> item) {
    // Déterminer le type d'événement et ses attributs visuels
    Color cardBorderColor;
    Color badgeColor;
    IconData statusIcon;
    String statusText;
    if (item['typeAbsence'] == "PRESENT") {
      // Présence normale
      cardBorderColor = AppTheme.secondaryColor;
      badgeColor = Colors.green.shade300;
      statusIcon = Icons.check_circle_outline;
      statusText = "Présence";
    } else if (item['typeAbsence'] == "RETARD") {
      // Retard
      cardBorderColor = AppTheme.secondaryColor;
      badgeColor = Colors.amber.shade300;
      statusIcon = Icons.watch_later_outlined;
      statusText = "Retard ${item['minutesRetard']} min";
    } else {
      // Absence
      cardBorderColor = AppTheme.secondaryColor;
      badgeColor = Colors.red.shade300;
      statusIcon = Icons.person_off_outlined;
      statusText = "Absence";
    }

    return Card(
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
                // Heure d'arrivée
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
                        item['heureArrivee'] ?? '--:--',
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
                // Information sur l'étudiant
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      radius: 20,
                      child: Text(
                        _getInitials(item['etudiantNom'] ?? '??'),
                        style: TextStyle(
                          color: cardBorderColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['etudiantNom'] ?? 'Étudiant inconnu',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.badge_outlined,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['matricule'] ?? 'Non spécifié',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Détails sur le cours
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.menu_book_outlined,
                            size: 16,
                            color: Colors.indigo,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['coursNom'] ?? 'Non spécifié',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.event_outlined,
                          size: 16,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(item['date'] ?? ''),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
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
    );
  }

  // Méthode utilitaire pour obtenir les initiales d'un nom
  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }

    return name[0].toUpperCase();
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';

    final dateParts = dateStr.split('-');
    if (dateParts.length < 3) return dateStr;

    return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: _buildAppBar() as PreferredSizeWidget?,
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
                      : _buildHistoriqueList(controller.filteredHistorique),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
