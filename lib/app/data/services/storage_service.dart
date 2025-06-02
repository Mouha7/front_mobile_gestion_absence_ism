import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Getter pour le token
  String? get token => _prefs.getString('token');

  // Setter pour le token
  Future<bool> setToken(String token) async {
    return await _prefs.setString('token', token);
  }

  // Supprimer le token
  Future<bool> removeToken() async {
    return await _prefs.remove('token');
  }

  // Sauvegarder les données utilisateur
  Future<bool> saveUser(Map<String, dynamic> userData) async {
    try {
      // Conversion en JSON pour stockage sécurisé
      return await _prefs.setString('user', jsonEncode(userData));
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde des données utilisateur: $e');
      return false;
    }
  }

  // Récupérer les données utilisateur
  Map<String, dynamic>? getUser() {
    final userStr = _prefs.getString('user');
    print('Récupération des données utilisateur dans storage : $userStr');
    if (userStr != null && userStr.isNotEmpty) {
      try {
        // Conversion de la chaîne JSON en Map
        return jsonDecode(userStr) as Map<String, dynamic>;
      } catch (e) {
        print('❌ Erreur lors de la récupération des données utilisateur: $e');
      }
    }
    return null;
  }

  // Vérifier si l'utilisateur est connecté
  bool isLoggedIn() {
    return token != null;
  }

  // Déconnecter l'utilisateur
  Future<void> logout() async {
    await _prefs.remove('token');
    await _prefs.remove('user');
  }
}
