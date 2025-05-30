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
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.brown[800],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
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
        Container(
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
      ],
    );
  }

  Widget _buildAbsencesList(List<Map<String, dynamic>> absences) {
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
                  // Indicateur de connexion au serveur - visible temporairement
                  Obx(
                    () => AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: controller.showConnectionStatus.value ? 40 : 0,
                      margin: EdgeInsets.only(
                        bottom: controller.showConnectionStatus.value ? 16 : 0,
                      ),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity:
                            controller.showConnectionStatus.value ? 1.0 : 0.0,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color:
                                controller.isServerConnected.value
                                    ? Colors.green.withOpacity(0.7)
                                    : Colors.red.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                controller.isServerConnected.value
                                    ? Icons.cloud_done
                                    : Icons.cloud_off,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                controller.isServerConnected.value
                                    ? 'Connecté au serveur'
                                    : 'Serveur non accessible',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildSearchBar(),
                  _buildFilterSection(),
                  controller.isLoading.value
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                      : _buildAbsencesList(controller.absences),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
