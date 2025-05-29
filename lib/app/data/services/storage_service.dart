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
    return await _prefs.setString('user', userData.toString());
  }

  // Récupérer les données utilisateur
  Map<String, dynamic>? getUser() {
    final userStr = _prefs.getString('user');
    if (userStr != null) {
      // Conversion de la chaîne en Map
      // Note: Dans un cas réel, utilisez json.decode
      return {'id': '1', 'nom': 'Test'}; // Exemple simplifié
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