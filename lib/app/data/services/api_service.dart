import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';

class ApiService extends GetxService {
  // URL de json-server qui s'exécute par défaut sur le port 3000
  // L'URL sera automatiquement configurée en fonction de la plateforme
  final RxString _baseUrl = ''.obs;

  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _initBaseUrl();
    print('ApiService initialisé avec URL: ${_baseUrl.value}');

    // Sur iOS physique, essayer de détecter automatiquement une URL de serveur qui fonctionne
    if (Platform.isIOS && !kIsWeb) {
      _autoDetectServerUrl();
    }
  }

  // Tente de détecter automatiquement une URL de serveur qui fonctionne
  Future<void> _autoDetectServerUrl() async {
    print('Tentative de détection automatique de l\'URL du serveur...');

    // Liste des adresses IP courantes à tester
    final List<String> potentialIps = [
      'localhost', // Simulateur iOS
      '10.0.2.2', // Émulateur Android
      '127.0.0.1', // Localhost alternatif
    ];

    // Ajouter des plages d'IP communes pour les réseaux locaux
    // Ces adresses IP sont couramment utilisées dans les réseaux domestiques
    for (int lastOctet = 1; lastOctet <= 20; lastOctet++) {
      potentialIps.add('192.168.1.$lastOctet');
      potentialIps.add('192.168.0.$lastOctet');
      // Ajouter d'autres plages possibles
      if (lastOctet <= 10) {
        potentialIps.add('10.0.0.$lastOctet');
        potentialIps.add('172.16.0.$lastOctet');
      }
    }

    bool foundWorkingUrl = false;
    int testedUrls = 0;
    final int maxUrlsToTest =
        10; // Limiter le nombre d'URL à tester pour éviter un délai trop long

    for (String ip in potentialIps) {
      if (testedUrls >= maxUrlsToTest) break;

      final testUrl = 'http://$ip:3000';
      print('Test de connexion à $testUrl...');
      testedUrls++;

      try {
        // Utiliser un timeout court pour éviter d'attendre trop longtemps
        final response = await http
            .get(
              Uri.parse('$testUrl/utilisateurs'),
              headers: {'Accept': 'application/json'},
            )
            .timeout(Duration(seconds: 2));

        final bool success = response.statusCode == 200;

        if (success) {
          print('✅ Connexion réussie à $testUrl');
          _baseUrl.value = testUrl;
          foundWorkingUrl = true;
          break;
        } else {
          print(
            '❌ Échec de connexion à $testUrl (code: ${response.statusCode})',
          );
        }
      } catch (e) {
        print('❌ Erreur lors du test de $testUrl: ${e.runtimeType}');
      }
    }

    if (foundWorkingUrl) {
      print('🔍 URL de serveur fonctionnelle détectée: ${_baseUrl.value}');
    } else {
      print('⚠️ Aucune URL de serveur fonctionnelle trouvée automatiquement.');
      // Ne pas modifier l'URL, celle définie dans _initBaseUrl sera utilisée
    }
  }

  // Initialise l'URL de base en fonction de la plateforme
  void _initBaseUrl() {
    if (kIsWeb) {
      // Application web
      _baseUrl.value = 'http://localhost:3000';
      print('Plateforme détectée: Web');
    } else if (Platform.isAndroid) {
      // Émulateur Android utilise 10.0.2.2 pour accéder à localhost de la machine hôte
      _baseUrl.value = 'http://10.0.2.2:3000';
      print('Plateforme détectée: Android');
    } else if (Platform.isIOS) {
      // Pour iOS, nous devons déterminer si nous sommes sur un simulateur ou un appareil physique
      // Sur iOS, nous allons d'abord essayer localhost qui fonctionne pour le simulateur
      _baseUrl.value = 'http://localhost:3000';
      print('Plateforme détectée: iOS');

      // La détection automatique de l'appareil physique vs simulateur sera gérée par _autoDetectServerUrl()
      // qui sera appelé dans onInit()
    } else {
      // Autres plateformes (macOS, Windows, Linux)
      _baseUrl.value = 'http://localhost:3000';
      print('Plateforme détectée: Autre (${Platform.operatingSystem})');
    }
  }

  String get baseUrl => _baseUrl.value;

  // Méthode pour changer dynamiquement l'URL de base
  void setBaseUrl(String url) {
    _baseUrl.value = url;
    print('URL de base modifiée: $_baseUrl');
  }

  // Méthode pour utiliser une adresse IP personnalisée (pour les appareils physiques)
  void useCustomIpAddress(String ipAddress) {
    setBaseUrl('http://$ipAddress:3000');
  }

  // Méthode pour revenir à l'URL par défaut pour la plateforme courante
  void resetToDefaultUrl() {
    _initBaseUrl();
  }

  Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = _storageService.token;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requireAuth = true}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<dynamic> post(
    String endpoint,
    dynamic data, {
    bool requireAuth = true,
  }) async {
    final headers = await _getHeaders(requireAuth: requireAuth);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<dynamic> put(
    String endpoint,
    dynamic data, {
    bool requireAuth = true,
  }) async {
    final headers = await _getHeaders(requireAuth: requireAuth);

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<dynamic> delete(String endpoint, {bool requireAuth = true}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw Exception('Requête incorrecte: ${response.body}');
      case 401:
      case 403:
        throw Exception('Non autorisé: ${response.body}');
      case 404:
        throw Exception('Non trouvé: ${response.body}');
      case 500:
      default:
        throw Exception('Erreur serveur: ${response.body}');
    }
  }

  // Méthode pour tester la connexion au serveur
  Future<bool> testConnection() async {
    try {
      print('Test de connexion à: $baseUrl/utilisateurs');
      final response = await http
          .get(
            Uri.parse('$baseUrl/utilisateurs'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(Duration(seconds: 5));

      final bool isConnected = response.statusCode == 200;
      print(
        'Résultat du test de connexion: ${isConnected ? 'Succès' : 'Échec'} (${response.statusCode})',
      );

      if (isConnected) {
        // Afficher des informations sur le serveur connecté
        print('Serveur connecté à l\'URL: $baseUrl');
        print(
          'Plateforme de l\'application: ${kIsWeb ? 'Web' : Platform.operatingSystem}',
        );

        try {
          final List<dynamic> data = jsonDecode(response.body);
          print('Nombre d\'utilisateurs récupérés: ${data.length}');
        } catch (e) {
          print('Erreur lors de l\'analyse des données: $e');
        }
      }

      return isConnected;
    } catch (e) {
      print('Erreur de connexion au serveur: $e');
      return false;
    }
  }
}
