import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/historique_pointage_controller.dart';
import 'pointage_detail_view.dart';

class HistoriquePointageView extends GetView<HistoriquePointageController> {
  const HistoriquePointageView({super.key});

  Color get brown => const Color(0xFF7A4B27);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brown,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
        title: const Text(
          'Historique pointage',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            TextField(
              onChanged: controller.onSearchChanged,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Rechercher',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Text('Filtrer par :', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 10),
                Obx(
                  () => DropdownButton<String>(
                    value: controller.filterType.value,
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                    items: const [
                      DropdownMenuItem(value: 'Date', child: Text('Date')),
                    ],
                    onChanged: controller.onFilterTypeChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Liste des pointages
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredPointages.isEmpty) {
                  return const Center(child: Text('Aucun pointage trouvé.', style: TextStyle(color: Colors.white)));
                }
                return ListView.builder(
                  itemCount: controller.filteredPointages.length,
                  itemBuilder: (context, index) {
                    final p = controller.filteredPointages[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        onTap: () => Get.to(() => PointageDetailView(pointage: p)),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: brown.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.home, color: Color(0xFF7A4B27), size: 30),
                        ),
                        title: Text(
                          p.matiere,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.date, style: TextStyle(color: brown, fontSize: 13)),
                            Text(p.heure, style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                        trailing: Text(
                          p.classe,
                          style: const TextStyle(
                            color: Color(0xFF1E386B),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}