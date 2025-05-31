import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';

class ApiService extends GetxService {
  // URL de l'API backend Spring Boot sur Render
  String baseUrl = 'https://ism-absences-api.onrender.com/api/mobile';
  final StorageService _storageService = Get.find<StorageService>();

  // Délai d'attente configurable (plus long pour les tests de connexion)
  final Duration timeout = const Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();
    print('API Service: URL configurée -> $baseUrl');
  }

  // Méthode pour mettre à jour l'URL de base (utile pour le mode développement)
  void updateBaseUrl(String newUrl) {
    baseUrl = newUrl;
    print('API Service: URL de base mise à jour -> $baseUrl');
  }

  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    // Headers de base pour l'API
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Ajoute l'authentification uniquement si demandé explicitement
    if (requireAuth) {
      final token = _storageService.token;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);

    // Nettoie l'endpoint pour éviter les problèmes de double slash
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }

    try {
      final url = '$baseUrl/$endpoint';
      print('🔍 GET: $url');

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(
            timeout,
            onTimeout: () => throw Exception('Délai d\'attente dépassé'),
          );

      return _processResponse(response);
    } catch (e) {
      print('❌ Erreur GET: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<dynamic> post(
    String endpoint,
    dynamic data, {
    bool requireAuth = false,
  }) async {
    final headers = await _getHeaders(requireAuth: requireAuth);

    // Nettoie l'endpoint pour éviter les problèmes de double slash
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }

    try {
      final url = '$baseUrl/$endpoint';
      print('📤 POST: $url');
      print('📦 Données: ${jsonEncode(data)}');

      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(
            timeout,
            onTimeout: () => throw Exception('Délai d\'attente dépassé'),
          );

      return _processResponse(response);
    } catch (e) {
      print('❌ Erreur POST: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<dynamic> put(
    String endpoint,
    dynamic data, {
    bool requireAuth = false,
  }) async {
    final headers = await _getHeaders(requireAuth: requireAuth);

    // Nettoie l'endpoint pour éviter les problèmes de double slash
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }

    try {
      final url = '$baseUrl/$endpoint';
      print('🔄 PUT: $url');
      print('📦 Données: ${jsonEncode(data)}');

      final response = await http
          .put(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(
            timeout,
            onTimeout: () => throw Exception('Délai d\'attente dépassé'),
          );

      return _processResponse(response);
    } catch (e) {
      print('❌ Erreur PUT: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<dynamic> delete(String endpoint, {bool requireAuth = false}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);

    // Nettoie l'endpoint pour éviter les problèmes de double slash
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }

    try {
      final url = '$baseUrl/$endpoint';
      print('🗑️ DELETE: $url');

      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(
            timeout,
            onTimeout: () => throw Exception('Délai d\'attente dépassé'),
          );

      return _processResponse(response);
    } catch (e) {
      print('❌ Erreur DELETE: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    // Log pour le débogage
    print('📡 Réponse [${response.statusCode}]');
    if (response.body.isNotEmpty) {
      print(
        '📄 Corps: ${response.body.length > 200 ? '${response.body.substring(0, 200)}...' : response.body}',
      );
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 304: // Non modifié - json-server utilise parfois ce code
        if (response.body.isEmpty) {
          return {};
        }
        try {
          return jsonDecode(response.body);
        } catch (e) {
          print('⚠️ Erreur de décodage JSON: $e');
          throw Exception('Format de réponse invalide');
        }
      case 400:
        throw Exception('Requête incorrecte: ${response.body}');
      case 401:
      case 403:
        throw Exception('Non autorisé: ${response.body}');
      case 404:
        throw Exception('Ressource non trouvée: ${response.body}');
      case 500:
      default:
        throw Exception(
          'Erreur serveur: ${response.statusCode} - ${response.body}',
        );
    }
  }

  // Méthode pour vérifier si le serveur est disponible
  Future<bool> isServerAvailable() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('❌ Erreur de connexion au serveur: $e');
      return false;
    }
  }
}
