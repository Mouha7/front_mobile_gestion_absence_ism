import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';

class EtudiantAbsencesView extends GetView<EtudiantController> {
  const EtudiantAbsencesView({super.key});

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Historique des absences',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {},
        ),
        SizedBox(width: 8),
      ],
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  // Supprimer tous les bordures et décorations non désirées
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // Ajouter un préfixe d'icône pour montrer que le filtrage est actif
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
              child: Icon(Icons.search, color: Colors.white),
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
          Text(
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
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      SizedBox(width: 4),
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
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

  Widget _buildAbsencesList(List<Map<String, dynamic>> absences) {
    // Si la liste est vide après une recherche ou un filtrage par date, afficher un message
    if (absences.isEmpty &&
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
            'Aucune absence à la date du ${controller.selectedDate.value!.day.toString().padLeft(2, '0')}/${controller.selectedDate.value!.month.toString().padLeft(2, '0')}/${controller.selectedDate.value!.year}';
      }

      return Container(
        margin: EdgeInsets.only(top: 32),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
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
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: absences.length,
        separatorBuilder:
            (context, index) => Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.grey[300],
            ),
        itemBuilder: (context, index) {
          final absence = absences[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF452917),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.home, color: Colors.white),
              ),
              title: Text(
                absence['matiere'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                '${absence['date']} - ${absence['duree']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    absence['professeur'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 14),
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
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  _buildFilterSection(),
                  controller.isLoading.value
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
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
}
