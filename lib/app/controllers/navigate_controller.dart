import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:front_mobile_gestion_absence_ism/app/controllers/etudiant_controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class NavigateController extends GetxController {
  final MapController mapController = MapController();
  final EtudiantController etudiantController = Get.find<EtudiantController>();

  // Position du campus ISM
  final LatLng ismPosition = LatLng(
    14.690904,
    -17.458394,
  ); // Position exacte du campus ISM

  // Variables Rx pour l'état
  final RxList<LatLng> routePoints = <LatLng>[].obs;
  final RxBool isLoadingRoute = false.obs;
  final RxBool routeError = false.obs;
  final Rx<String> selectedTransport = 'marche'.obs;
  final RxBool showInfoCard = true.obs;
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);

  // Variables pour les itinéraires alternatifs
  final RxList<List<LatLng>> alternativeRoutes = <List<LatLng>>[].obs;
  final RxInt selectedRouteIndex = 0.obs; // 0 = route principale

  @override
  void onInit() {
    super.onInit();
    getCurrentPosition();
  }

  // Méthode pour obtenir la position actuelle
  Future<void> getCurrentPosition() async {
    isLoadingRoute.value = true;

    try {
      Position position = await _determinePosition();
      currentPosition.value = LatLng(position.latitude, position.longitude);

      // Calculer automatiquement le meilleur itinéraire quand on a la position
      await calculateBestRoute();
    } catch (e) {
      print('Erreur lors de l\'obtention de la position: $e');
      routeError.value = true;
    } finally {
      isLoadingRoute.value = false;
    }
  }

  // Méthode pour déterminer la position actuelle de l'utilisateur
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifier si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Afficher une boîte de dialogue pour demander à l'utilisateur d'activer la localisation
      await Get.dialog(
        AlertDialog(
          title: const Text('Localisation désactivée'),
          content: const Text(
            'Veuillez activer la localisation pour utiliser cette fonctionnalité.',
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text('Paramètres'),
              onPressed: () async {
                Get.back();
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        ),
      );
      return Future.error('Les services de localisation sont désactivés');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation ont été refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Les permissions de localisation sont refusées définitivement, nous ne pouvons pas demander de permissions',
      );
    }

    // Tout est OK, on peut obtenir la position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }

  // Calculer le meilleur itinéraire et alternatives
  Future<void> calculateBestRoute() async {
    if (currentPosition.value == null) {
      await getCurrentPosition();
      if (currentPosition.value == null) return;
    }

    isLoadingRoute.value = true;
    routeError.value = false;

    try {
      // Récupérer l'itinéraire principal et les alternatives
      final mainRoute = await _getRoutePoints(
        currentPosition.value!,
        ismPosition,
        selectedTransport.value,
        alternatives: true,
      );

      if (mainRoute.isNotEmpty) {
        routePoints.assignAll(mainRoute['mainRoute']);

        // Stocker les itinéraires alternatifs
        alternativeRoutes.clear();
        if (mainRoute['alternatives'] != null &&
            mainRoute['alternatives'].isNotEmpty) {
          alternativeRoutes.assignAll(mainRoute['alternatives']);
        }

        // Sélectionner par défaut l'itinéraire principal
        selectedRouteIndex.value = 0;
      } else {
        routeError.value = true;
      }
    } catch (e) {
      print('Erreur lors du calcul du meilleur itinéraire: $e');
      routeError.value = true;
    } finally {
      isLoadingRoute.value = false;
    }
  }

  // Changer l'itinéraire sélectionné
  void selectRoute(int index) {
    if (index == 0) {
      // Itinéraire principal
      selectedRouteIndex.value = 0;
    } else if (index <= alternativeRoutes.length) {
      // Itinéraires alternatifs (1-based pour les alternatives)
      selectedRouteIndex.value = index;
    }
  }

  // Obtenir l'itinéraire actuellement sélectionné
  List<LatLng> get selectedRoute {
    if (selectedRouteIndex.value == 0) {
      return routePoints;
    } else {
      return alternativeRoutes[selectedRouteIndex.value - 1];
    }
  }

  // Calculer la distance de l'itinéraire
  double calculateRouteDistance(List<LatLng> points) {
    double distance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      distance += _calculateDistance(points[i], points[i + 1]);
    }
    return distance;
  }

  // Estimer le temps de parcours en fonction du transport choisi
  Map<String, dynamic> estimateTravelTime(
    List<LatLng> points,
    String transportMode,
  ) {
    final distance = calculateRouteDistance(points);

    double speed;
    IconData icon;

    switch (transportMode) {
      case 'velo':
        speed = 0.25; // 15 km/h = 0.25 km/min
        icon = Icons.directions_bike;
        break;
      case 'voiture':
        speed = 0.67; // 40 km/h = 0.67 km/min en ville
        icon = Icons.directions_car;
        break;
      case 'scooter':
        speed = 0.33; // 20 km/h = 0.33 km/min
        icon = Icons.electric_scooter;
        break;
      case 'marche':
      default:
        speed = 0.0833; // 5 km/h = 0.0833 km/min
        icon = Icons.directions_walk;
    }

    final travelTimeInMinutes = (distance / speed).round();
    final hours = travelTimeInMinutes ~/ 60;
    final minutes = travelTimeInMinutes % 60;

    String timeText;
    if (hours > 0) {
      timeText =
          '${hours}h ${minutes.toString().padLeft(2, '0')}min ($travelTimeInMinutes min)';
    } else {
      timeText = '$minutes min';
    }

    return {
      'distance': distance,
      'time': timeText,
      'minutes': travelTimeInMinutes,
      'icon': icon,
    };
  }

  // Méthode pour récupérer les points de l'itinéraire avec alternatives
  Future<Map<String, dynamic>> _getRoutePoints(
    LatLng start,
    LatLng end,
    String transportMode, {
    bool alternatives = false,
  }) async {
    // Convertir le mode de transport pour l'API OSRM
    String profile;
    switch (transportMode) {
      case 'velo':
        profile = 'cycling';
        break;
      case 'voiture':
        profile = 'driving';
        break;
      case 'scooter':
        // OSRM ne propose pas de profil scooter
        profile = 'cycling';
        break;
      case 'marche':
      default:
        profile = 'walking';
    }

    try {
      // Requête avec alternatives si demandé
      final response = await http
          .get(
            Uri.parse(
              'https://router.project-osrm.org/route/v1/$profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=polyline&alternatives=${alternatives ? 'true' : 'false'}',
            ),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          final result = <String, dynamic>{};

          // Route principale
          final mainRoute = _decodePolyline(data['routes'][0]['geometry']);
          result['mainRoute'] = mainRoute;

          // Routes alternatives
          if (alternatives && data['routes'].length > 1) {
            final List<List<LatLng>> alternativesList = [];

            for (int i = 1; i < data['routes'].length; i++) {
              final routePoints = _decodePolyline(
                data['routes'][i]['geometry'],
              );
              alternativesList.add(routePoints);
            }

            result['alternatives'] = alternativesList;
          } else {
            result['alternatives'] = <List<LatLng>>[];
          }

          return result;
        }
      }

      return {'mainRoute': <LatLng>[], 'alternatives': <List<LatLng>>[]};
    } catch (e) {
      print('Erreur lors de la récupération de l\'itinéraire: $e');
      return {'mainRoute': <LatLng>[], 'alternatives': <List<LatLng>>[]};
    }
  }

  // Méthode pour décoder la polyline et obtenir les points de l'itinéraire
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  // Méthode pour calculer la distance entre deux points en kilomètres
  double _calculateDistance(LatLng point1, LatLng point2) {
    const int earthRadius = 6371; // Rayon de la Terre en km

    // Convertir les degrés en radians
    final double lat1 = point1.latitude * (pi / 180);
    final double lon1 = point1.longitude * (pi / 180);
    final double lat2 = point2.latitude * (pi / 180);
    final double lon2 = point2.longitude * (pi / 180);

    // Formule de Haversine
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  // Déterminer le centre de la carte pour afficher à la fois l'utilisateur et la destination
  LatLng getCenterPoint(LatLng point1, LatLng point2) {
    return LatLng(
      (point1.latitude + point2.latitude) / 2,
      (point1.longitude + point2.longitude) / 2,
    );
  }

  // Calculer le niveau de zoom approprié en fonction de la distance
  double calculateZoomLevel(LatLng point1, LatLng point2) {
    double distance = _calculateDistance(point1, point2);
    // Adaptation du zoom selon la distance
    if (distance > 10) return 11;
    if (distance > 5) return 12;
    if (distance > 2) return 13;
    if (distance > 1) return 14;
    return 15;
  }
}
