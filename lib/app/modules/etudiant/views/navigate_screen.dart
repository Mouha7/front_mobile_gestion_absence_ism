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
          // Bouton pour rafraîchir l'itinéraire
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.calculateBestRoute(),
            tooltip: 'Rafraîchir l\'itinéraire',
          ),
          // Bouton pour afficher les alternatives
          Obx(() => controller.alternativeRoutes.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.alt_route, color: Colors.white),
                onPressed: () => _showRouteSelector(context),
                tooltip: 'Itinéraires alternatifs',
              ) 
            : const SizedBox.shrink()
          ),
        ],
      ),
      body: Obx(() {
        if (controller.currentPosition.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                center: controller.getCenterPoint(
                  controller.currentPosition.value!,
                  controller.ismPosition
                ),
                zoom: controller.calculateZoomLevel(
                  controller.currentPosition.value!,
                  controller.ismPosition
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

                // Afficher l'itinéraire principal et les alternatives
                PolylineLayer(
                  polylines: [
                    // Itinéraire principal 
                    if (controller.selectedRouteIndex.value == 0 && controller.routePoints.isNotEmpty)
                      Polyline(
                        points: controller.routePoints,
                        strokeWidth: 5.0,
                        color: AppTheme.primaryColor,
                      ),
                    
                    // Itinéraires alternatifs (si sélectionné)
                    if (controller.selectedRouteIndex.value > 0 && 
                        controller.selectedRouteIndex.value <= controller.alternativeRoutes.length)
                      Polyline(
                        points: controller.alternativeRoutes[controller.selectedRouteIndex.value - 1],
                        strokeWidth: 5.0,
                        color: AppTheme.primaryColor,
                      ),
                    
                    // Afficher les autres itinéraires alternatifs en grisé
                    ...controller.alternativeRoutes.asMap().entries.map(
                      (entry) => controller.selectedRouteIndex.value != entry.key + 1
                          ? Polyline(
                              points: entry.value,
                              strokeWidth: 3.0,
                              color: Colors.grey.withOpacity(0.5),
                              isDotted: true,
                            )
                          : Polyline(points: [])
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
                ),

                MarkerLayer(
                  markers: [
                    // Marqueur pour la position actuelle
                    Marker(
                      point: controller.currentPosition.value!,
                      width: 80,
                      height: 80,
                      builder: (ctx) => const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    
                    // Marqueur pour le campus ISM
                    Marker(
                      point: controller.ismPosition,
                      width: 80,
                      height: 80,
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Indicateur de chargement de l'itinéraire
            if (controller.isLoadingRoute.value)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Calcul du meilleur itinéraire...",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Message d'erreur d'itinéraire
            if (controller.routeError.value && !controller.isLoadingRoute.value)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 10),
                        const Text(
                          "Impossible de calculer l'itinéraire",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text("Réessayer"),
                          onPressed: () => controller.calculateBestRoute(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Indicateur d'itinéraire alternatif sélectionné
            if (controller.selectedRouteIndex.value > 0)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.alt_route, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Itinéraire alternatif ${controller.selectedRouteIndex.value}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Carte d'informations conditionnelle
            if (controller.showInfoCard.value)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _buildInfoCard(context),
              )
            else
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.info, color: Colors.white),
                  onPressed: () => controller.showInfoCard.value = true,
                ),
              ),
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

  // Méthode pour afficher le sélecteur d'itinéraires alternatifs
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                // Itinéraire principal + alternatives
                final routes = [controller.routePoints, ...controller.alternativeRoutes];
                
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: routes.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    // Calculer les détails de l'itinéraire
                    final routeDetails = controller.estimateTravelTime(
                      routes[index],
                      controller.selectedTransport.value,
                    );
                    
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.selectedRouteIndex.value == index
                              ? AppTheme.primaryColor
                              : Colors.grey.shade200,
                        ),
                        child: Center(
                          child: Icon(
                            index == 0 ? Icons.star : Icons.alt_route,
                            color: controller.selectedRouteIndex.value == index
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                      title: Text(
                        index == 0 ? 'Meilleur itinéraire' : 'Alternative $index',
                        style: TextStyle(
                          fontWeight: controller.selectedRouteIndex.value == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        '${routeDetails['distance'].toStringAsFixed(1)} km • ${routeDetails['time']}',
                      ),
                      trailing: controller.selectedRouteIndex.value == index
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      selected: controller.selectedRouteIndex.value == index,
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

  // Widget pour afficher la carte d'information
  Widget _buildInfoCard(BuildContext context) {
    return Obx(() {
      // Obtenir les détails de l'itinéraire sélectionné
      final List<LatLng> currentRoute = controller.selectedRouteIndex.value == 0
          ? controller.routePoints
          : controller.alternativeRoutes[controller.selectedRouteIndex.value - 1];
      
      final routeDetails = controller.estimateTravelTime(
        currentRoute,
        controller.selectedTransport.value,
      );

      return Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.school,
                    color: Colors.brown,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'ISM Campus Baobab',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Afficher le numéro de l'itinéraire s'il y a des alternatives
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
              ),
              const Divider(),

              // Options de transport
              const Text(
                'Mode de transport',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTransportOption(
                      'marche',
                      'À pied',
                      Icons.directions_walk,
                    ),
                    const SizedBox(width: 8),
                    _buildTransportOption(
                      'velo',
                      'À vélo',
                      Icons.directions_bike,
                    ),
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
              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(
                    Icons.directions_walk,
                    color: Colors.grey,
                  ),
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
                  const Icon(
                    Icons.timer,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Icon(
                        routeDetails['icon'],
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Temps estimé : ~${routeDetails['time']}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bouton pour recalculer l'itinéraire (en marron)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Recalculer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D4C41),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => controller.calculateBestRoute(),
                ),
              ),
            ],
          ),
        )
      );
    });
  }

  // Widget pour créer une option de transport
  Widget _buildTransportOption(
    String value,
    String label,
    IconData icon,
  ) {
    return Obx(() {
      bool isSelected = controller.selectedTransport.value == value;
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
