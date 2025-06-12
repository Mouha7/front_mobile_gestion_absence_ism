import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Utiliser SafeArea pour éviter les débordements
    return SafeArea(
      // Spécifier bottom: false pour éviter l'espace supplémentaire en bas
      bottom: false,
      child: Container(
        height: 90, // Hauteur réduite pour éviter le débordement
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppTheme.blurColor,
              blurRadius: 8, // Réduction du flou
              spreadRadius: 0, // Réduction de l'étendue
              offset: const Offset(0, -1), // Ombre plus subtile
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: onTap,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey.shade500,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11, // Taille réduite
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 11, // Taille réduite
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 2), // Padding réduit
                  child: Icon(Icons.home_outlined, size: 22), // Taille réduite
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 2), // Padding réduit
                  child: Icon(Icons.home, size: 24), // Taille réduite
                ),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 2), // Padding réduit
                  child: Icon(
                    Icons.navigation_outlined,
                    size: 22,
                  ), // Taille réduite
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 2), // Padding réduit
                  child: Icon(Icons.navigation, size: 24), // Taille réduite
                ),
                label: 'Navigation',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
