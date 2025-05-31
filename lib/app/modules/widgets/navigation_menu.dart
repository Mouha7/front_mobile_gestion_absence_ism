import 'package:flutter/material.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  final RxString activeTab;
  final VoidCallback onScannerTap;
  final VoidCallback onHistoriqueTap;

  const NavigationMenu({
    super.key,
    required this.activeTab,
    required this.onScannerTap,
    required this.onHistoriqueTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            'scanner',
            Icons.qr_code_scanner_rounded,
            'Scanner',
            onScannerTap,
          ),
          _buildNavItem(
            'historique',
            Icons.history_rounded,
            'Historique',
            onHistoriqueTap,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    String tabName,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Obx(() {
      final bool isActive = activeTab.value == tabName;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.secondaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey,
                size: 20,
              ),
              if (isActive) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ] else
                const SizedBox(width: 4),
              if (!isActive)
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
