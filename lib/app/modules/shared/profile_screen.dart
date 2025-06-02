import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';

class ProfilMenu extends StatelessWidget {
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final Function() onLogout;
  final bool isLoading;

  const ProfilMenu({
    super.key,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    required this.onLogout,
    this.isLoading = false,
  });

  Color get brown => const Color(0xFF7A4B27);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),
      body: Center(
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
              // Photo de profil avec overlay d'icône de photo
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3A9E8C),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${prenom[0]}${nom[0]}",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A9E8C),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A9E8C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Nom complet
              Text(
                "$prenom $nom",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              // Email et rôle
              Text(
                email,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                role,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              // Options de menu avec icônes et séparateurs
              _profilMenuItem(Icons.person_outline, "Modifier Profile", () {}),
              const Divider(height: 1, indent: 25, endIndent: 25,),
              _profilMenuItem(
                Icons.notifications_outlined,
                "Notifications",
                () {},
              ),
              const Divider(height: 1, indent: 25, endIndent: 25,),
              _profilMenuItemWithValue(
                Icons.translate,
                "Langue",
                "Français",
                () {},
              ),
              const Divider(height: 1, indent: 25, endIndent: 25,),
              _profilMenuItem(
                Icons.shield_outlined,
                "Terms & Conditions",
                () {},
              ),
              const Divider(height: 1, indent: 25, endIndent: 25,),
              _profilMenuItem(Icons.help_outline, "Centre d'Aide", () {}),
              const Divider(height: 1, indent: 25, endIndent: 25,),
              _profilMenuItem(
                Icons.power_settings_new,
                "Déconnexion",
                onLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilMenuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 28),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }

  Widget _profilMenuItemWithValue(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 28),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}