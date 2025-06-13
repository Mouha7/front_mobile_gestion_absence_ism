// filepath: /Users/mac/Desktop/Ateliers/front_mobile_gestion_absence_ism/lib/app/modules/etudiant/views/navigate_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:front_mobile_gestion_absence_ism/app/routes/app_pages.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:front_mobile_gestion_absence_ism/app/modules/shared/widgets/bottom_nav_bar.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/navigate_controller.dart';
import 'package:front_mobile_gestion_absence_ism/theme/app_theme.dart';

class EtudiantNavigateView extends GetView<NavigateController> {
  const EtudiantNavigateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vers ISM Campus Baobab'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.calculateBestRoute,
            tooltip: 'Rafraîchir l\'itinéraire',
          ),
          Obx(
            () =>
                controller.alternativeRoutes.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.alt_route),
                      onPressed: () => _showRouteSelector(context),
                      tooltip: 'Itinéraires alternatifs',
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.currentPosition.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            _buildMap(),
            _buildStatusOverlays(),
            _buildInfoSection(context),
          ],
        );
      }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Get.offAllNamed(Routes.ETUDIANT_DASHBOARD);
          }
        },
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: controller.mapController,
      options: MapOptions(
        center: controller.getCenterPoint(
          controller.currentPosition.value!,
          controller.ismPosition,
        ),
        zoom: controller.calculateZoomLevel(
          controller.currentPosition.value!,
          controller.ismPosition,
        ),
        minZoom: 5.0,
        maxZoom: 18.0,
        keepAlive: true,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        _buildRouteLayer(),
        _buildMarkerLayer(),
      ],
    );
  }

  Widget _buildRouteLayer() {
    return PolylineLayer(
      polylines: [
        // Itinéraire principal
        if (controller.selectedRouteIndex.value == 0 &&
            controller.routePoints.isNotEmpty)
          Polyline(
            points: controller.routePoints,
            strokeWidth: 5.0,
            color: AppTheme.primaryColor,
          ),

        // Itinéraire alternatif sélectionné
        if (controller.selectedRouteIndex.value > 0 &&
            controller.selectedRouteIndex.value <=
                controller.alternativeRoutes.length)
          Polyline(
            points:
                controller
                    .alternativeRoutes[controller.selectedRouteIndex.value - 1],
            strokeWidth: 5.0,
            color: AppTheme.primaryColor,
          ),

        // Autres itinéraires alternatifs affichés en grisé
        for (int i = 0; i < controller.alternativeRoutes.length; i++)
          if (controller.selectedRouteIndex.value != i + 1)
            Polyline(
              points: controller.alternativeRoutes[i],
              strokeWidth: 3.0,
              color: Colors.grey.withOpacity(0.5),
              isDotted: true,
            ),

        // Ligne temporaire pendant le chargement
        if (controller.isLoadingRoute.value)
          Polyline(
            points: [controller.currentPosition.value!, controller.ismPosition],
            strokeWidth: 3.0,
            color: Colors.grey,
            isDotted: true,
          ),

        // Ligne d'erreur
        if (controller.routeError.value && !controller.isLoadingRoute.value)
          Polyline(
            points: [controller.currentPosition.value!, controller.ismPosition],
            strokeWidth: 4.0,
            color: Colors.red,
          ),
      ],
    );
  }

  Widget _buildMarkerLayer() {
    return MarkerLayer(
      markers: [
        Marker(
          point: controller.currentPosition.value!,
          width: 80,
          height: 80,
          builder:
              (ctx) =>
                  const Icon(Icons.my_location, color: Colors.blue, size: 30),
        ),

        Marker(
          point: controller.ismPosition,
          width: 80,
          height: 80,
          builder:
              (ctx) =>
                  const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      ],
    );
  }

  Widget _buildStatusOverlays() {
    return Stack(
      children: [
        // Indicateur de chargement
        if (controller.isLoadingRoute.value)
          _buildStatusBanner(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            ),
            text: "Calcul du meilleur itinéraire...",
            backgroundColor: Colors.white,
          ),

        // Message d'erreur
        if (controller.routeError.value && !controller.isLoadingRoute.value)
          _buildStatusBanner(
            icon: const Icon(Icons.error_outline, color: Colors.red),
            text: "Impossible de calculer l'itinéraire",
            backgroundColor: Colors.white,
            action: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: controller.calculateBestRoute,
              child: const Text("Réessayer"),
            ),
          ),

        // Indicateur d'itinéraire alternatif
        if (controller.selectedRouteIndex.value > 0)
          _buildStatusBanner(
            icon: const Icon(Icons.alt_route, color: Colors.white, size: 20),
            text:
                "Itinéraire alternatif ${controller.selectedRouteIndex.value}",
            backgroundColor: AppTheme.primaryColor,
            textColor: Colors.white,
          ),
      ],
    );
  }

  Widget _buildStatusBanner({
    required Widget icon,
    required String text,
    required Color backgroundColor,
    Widget? action,
    Color textColor = Colors.black87,
  }) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(text, style: TextStyle(fontSize: 14, color: textColor)),
              if (action != null) ...[const SizedBox(width: 10), action],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    if (controller.showInfoCard.value) {
      return Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: _buildInfoCard(context),
      );
    } else {
      return Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.info, color: Colors.white),
          onPressed: () => controller.showInfoCard.value = true,
        ),
      );
    }
  }

  void _showRouteSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choisissez un itinéraire',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final routes = [
                  controller.routePoints,
                  ...controller.alternativeRoutes,
                ];

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: routes.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final routeDetails = controller.estimateTravelTime(
                      routes[index],
                      controller.selectedTransport.value,
                    );

                    final isSelected =
                        controller.selectedRouteIndex.value == index;

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade200,
                        ),
                        child: Center(
                          child: Icon(
                            index == 0 ? Icons.star : Icons.alt_route,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                      title: Text(
                        index == 0
                            ? 'Meilleur itinéraire'
                            : 'Alternative $index',
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        '${routeDetails['distance'].toStringAsFixed(1)} km • ${routeDetails['time']}',
                      ),
                      trailing:
                          isSelected
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                              : null,
                      selected: isSelected,
                      selectedTileColor: Colors.grey.shade100,
                      onTap: () {
                        controller.selectRoute(index);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Obx(() {
      final List<LatLng> currentRoute =
          controller.selectedRouteIndex.value == 0
              ? controller.routePoints
              : controller
                  .alternativeRoutes[controller.selectedRouteIndex.value - 1];

      final routeDetails = controller.estimateTravelTime(
        currentRoute,
        controller.selectedTransport.value,
      );

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoCardHeader(context),
              const Divider(),
              _buildTransportOptions(),
              const SizedBox(height: 16),
              _buildRouteDetails(routeDetails),
              const SizedBox(height: 16),
              _buildRecalculateButton(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoCardHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.school, color: Colors.brown, size: 28),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'ISM Campus Baobab',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (controller.alternativeRoutes.isNotEmpty)
          TextButton.icon(
            icon: const Icon(Icons.alt_route, size: 16),
            label: Text(
              controller.selectedRouteIndex.value == 0
                  ? "Meilleur"
                  : "Alt. ${controller.selectedRouteIndex.value}",
              style: const TextStyle(fontSize: 12),
            ),
            onPressed: () => _showRouteSelector(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: () => controller.showInfoCard.value = false,
        ),
      ],
    );
  }

  Widget _buildTransportOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mode de transport',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTransportOption('marche', 'À pied', Icons.directions_walk),
              const SizedBox(width: 8),
              _buildTransportOption('velo', 'À vélo', Icons.directions_bike),
              const SizedBox(width: 8),
              _buildTransportOption(
                'voiture',
                'En voiture',
                Icons.directions_car,
              ),
              const SizedBox(width: 8),
              _buildTransportOption(
                'scooter',
                'En scooter',
                Icons.electric_scooter,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteDetails(Map<String, dynamic> routeDetails) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.directions_walk, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Distance : ${routeDetails['distance'].toStringAsFixed(1)} km',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.timer, color: Colors.grey),
            const SizedBox(width: 8),
            Row(
              children: [
                Icon(routeDetails['icon'], size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Temps estimé : ~${routeDetails['time']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text(
          'Recalculer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6D4C41),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: controller.calculateBestRoute,
      ),
    );
  }

  Widget _buildTransportOption(String value, String label, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedTransport.value == value;
      return GestureDetector(
        onTap: () {
          controller.selectedTransport.value = value;
          controller.calculateBestRoute();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6D4C41) : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black54,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
