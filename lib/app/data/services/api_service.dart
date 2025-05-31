import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';

class ApiService extends GetxService {
  // URL fixe du serveur
  // Pour un déploiement en production, utilisez l'URL de votre API réelle
  final String _baseUrl = 'http://localhost:3000';

  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    print('ApiService initialisé avec URL fixe: $_baseUrl');
  }

  String get baseUrl => _baseUrl;

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
      final response = await http
          .get(
            Uri.parse('$baseUrl/utilisateurs'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
