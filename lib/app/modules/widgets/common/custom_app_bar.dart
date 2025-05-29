// lib/widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF7B3F00),  
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 40),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.teal),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.image, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(userName, style: const TextStyle(fontSize: 16)),
                  Text(userEmail, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            _buildMenuItem(Icons.person, "Modifier Profil", onTap: () {}),
            _buildMenuItem(Icons.notifications, "Notifications", onTap: () {}),
            _buildMenuItem(Icons.language, "Langue", trailing: const Text("Français"), onTap: () {}),
            _buildMenuItem(Icons.description, "Terms & Conditions", onTap: () {}),
            _buildMenuItem(Icons.help, "Centre d’Aide", onTap: () {}),
            _buildMenuItem(Icons.logout, "Déconnexion", onTap: () {
              // Utilise ton AuthController ici
              Get.defaultDialog(
                title: "Déconnexion",
                middleText: "Souhaitez-vous vous déconnecter ?",
                textConfirm: "Oui",
                textCancel: "Non",
                onConfirm: () {
                  // Exemple :
                  // Get.find<AuthController>().logout();
                  Get.offAllNamed("/login");
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Widget? trailing, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
