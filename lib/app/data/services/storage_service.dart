import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService extends GetxService {
  late Box _authBox;
  
  // Les clés utilisées pour le stockage des données
  static const String authBoxName = 'auth_box';
  static const String tokenKey = 'token';
  static const String userDataKey = 'user_data';
  static const String lastSyncKey = 'last_sync';
  
  /// Initialiser le service de stockage Hive
  Future<StorageService> init() async {
    // Initialiser Hive
    await Hive.initFlutter();
    
    // Ouvrir la boîte de stockage d'authentification
    _authBox = await Hive.openBox(authBoxName);
    
    print('✅ StorageService avec Hive initialisé');
    return this;
  }
  
  /// Getter pour récupérer le token d'authentification
  String? get token => _authBox.get(tokenKey) as String?;
  
  /// Stocker le token d'authentification
  Future<bool> setToken(String token) async {
    await _authBox.put(tokenKey, token);
    return true;
  }
  
  /// Supprimer le token d'authentification
  Future<bool> removeToken() async {
    await _authBox.delete(tokenKey);
    return true;
  }
  
  /// Stocker les données de l'utilisateur
  Future<bool> saveUser(Map<String, dynamic> userData) async {
    try {
      // Convertir en JSON pour garantir la compatibilité
      final encodedData = jsonEncode(userData);
      await _authBox.put(userDataKey, encodedData);
      print('✅ Données utilisateur sauvegardées dans Hive');
      return true;
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde des données utilisateur: $e');
      return false;
    }
  }
  
  /// Récupérer les données de l'utilisateur
  Map<String, dynamic>? getUser() {
    try {
      final userDataString = _authBox.get(userDataKey) as String?;
      print('Récupération des données utilisateur dans Hive: $userDataString');
      
      if (userDataString != null && userDataString.isNotEmpty) {
        return jsonDecode(userDataString) as Map<String, dynamic>;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des données utilisateur: $e');
    }
    return null;
  }
  
  /// Vérifier si l'utilisateur est connecté
  bool isLoggedIn() {
    return token != null;
  }
  
  /// Déconnecter l'utilisateur (supprimer toutes les données)
  Future<void> logout() async {
    await _authBox.delete(tokenKey);
    await _authBox.delete(userDataKey);
  }
  
  /// Stocker la dernière date de synchronisation
  Future<void> saveLastSync(DateTime dateTime) async {
    await _authBox.put(lastSyncKey, dateTime.toIso8601String());
  }
  
  /// Récupérer la dernière date de synchronisation
  DateTime? getLastSync() {
    final dateString = _authBox.get(lastSyncKey) as String?;
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        print('❌ Erreur lors de la conversion de la date de synchronisation: $e');
      }
    }
    return null;
  }
  
  /// Nettoyer toutes les données stockées
  Future<void> clearAll() async {
    await _authBox.clear();
  }
}
