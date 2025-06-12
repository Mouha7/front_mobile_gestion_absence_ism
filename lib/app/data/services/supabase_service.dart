import 'dart:io';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService extends GetxService {
  late final SupabaseClient _supabaseClient;
  
  // Configuration - Vous utilisez Supabase UNIQUEMENT pour le stockage
  static const String _supabaseUrl = 'https://hxtdyxlhxmecheddfedt.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4dGR5eGxoeG1lY2hlZGRmZWR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg5Njg0MzYsImV4cCI6MjA2NDU0NDQzNn0.CVXC7Qjl2Xlfmy4YVHYsN4ItKnjE6YA5mTuEEJ5o8WQ';
  static const String _bucketName = 'justifications';

  Future<SupabaseStorageService> init() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
    _supabaseClient = Supabase.instance.client;
    
    print('✅ SupabaseStorageService initialisé');
    return this;
  }

  // Téléverser un fichier en mode anonyme (pas d'authentification Supabase)
  Future<String?> uploadFile(File file, {String? userId}) async {
    try {
      final String fileName = basename(file.path);
      // Utiliser l'ID utilisateur de MongoDB si disponible, sinon une valeur aléatoire
      final String userFolder = userId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      // Chemin du fichier dans Supabase Storage (userFolder/fichier)
      final String filePath = '$userFolder/$uniqueFileName';
      
      // Déterminer le type MIME du fichier
      final String? mimeType = lookupMimeType(file.path);
      
      // Lecture du fichier en bytes
      final fileBytes = await file.readAsBytes();
      
      // Téléversement sur Supabase (mode anonyme)
      final _ = await _supabaseClient
          .storage
          .from(_bucketName)
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: FileOptions(
              contentType: mimeType,
              cacheControl: '3600',
            ),
          );
      
      // Générer une URL publique pour le fichier
      final String publicUrl = _supabaseClient
          .storage
          .from(_bucketName)
          .getPublicUrl(filePath);
      
      print('✅ Fichier téléversé sur Supabase: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Erreur lors du téléversement du fichier sur Supabase: $e');
      return null;
    }
  }

  // Téléverser plusieurs fichiers
  Future<List<String>> uploadMultipleFiles(List<File> files, {String? userId}) async {
    try {
      final List<String> uploadedUrls = [];
      
      for (final file in files) {
        final String? url = await uploadFile(file, userId: userId);
        if (url != null) {
          uploadedUrls.add(url);
        }
      }
      
      return uploadedUrls;
    } catch (e) {
      print('❌ Erreur lors du téléversement multiple de fichiers: $e');
      return [];
    }
  }
}