import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_vigile_controller.dart';

class ProfilVigileView extends GetView<ProfilVigileController> {
  const ProfilVigileView({super.key});

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
      ),
      body: Obx(() {
        final v = controller.vigile.value;
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (v == null) {
          return const Center(child: Text('Erreur chargement profil', style: TextStyle(color: Colors.white)));
        }
        return Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: brown,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  "${v.prenom} ${v.nom}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(v.email, style: const TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox(height: 6),
                Chip(
                  label: Text("Badge : ${v.badge}", style: const TextStyle(color: Colors.white)),
                  backgroundColor: brown,
                ),
                const SizedBox(height: 30),
                profilMenuItem(Icons.person, "Modifier Profil", () {}),
                profilMenuItem(Icons.notifications, "Notifications", () {}),
                profilMenuItem(Icons.language, "Langue", () {}),
                profilMenuItem(Icons.article, "Terms & Conditions", () {}),
                profilMenuItem(Icons.help_center, "Centre d'aide", () {}),
                profilMenuItem(Icons.logout, "Déconnexion", controller.logout),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget profilMenuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: brown),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}