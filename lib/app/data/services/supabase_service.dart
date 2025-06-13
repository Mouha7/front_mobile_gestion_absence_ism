import 'dart:io';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SupabaseStorageService extends GetxService {
  late final SupabaseClient _supabaseClient;

  // Configuration - Vous utilisez Supabase UNIQUEMENT pour le stockage
  static const String _supabaseUrl = 'https://hxtdyxlhxmecheddfedt.supabase.co';
  static const String _supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4dGR5eGxoeG1lY2hlZGRmZWR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg5Njg0MzYsImV4cCI6MjA2NDU0NDQzNn0.CVXC7Qjl2Xlfmy4YVHYsN4ItKnjE6YA5mTuEEJ5o8WQ';
  static const String _bucketName = 'justifications';

  Future<SupabaseStorageService> init() async {
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);
    _supabaseClient = Supabase.instance.client;

    print('✅ SupabaseStorageService initialisé');
    return this;
  }

  // Téléverser un fichier en mode anonyme (pas d'authentification Supabase)
  Future<String?> uploadFile(File file, {String? userId}) async {
    try {
      String fileName = basename(file.path);
      // Nettoyer le nom du fichier pour éviter les erreurs Supabase
      fileName = _sanitizeFileName(fileName);
      
      // Utiliser l'ID utilisateur de MongoDB si disponible, sinon une valeur aléatoire
      final String userFolder =
          userId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final String uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // Chemin du fichier dans Supabase Storage (userFolder/fichier)
      final String filePath = '$userFolder/$uniqueFileName';

      // Déterminer le type MIME du fichier
      final String? mimeType = lookupMimeType(file.path);

      // Lecture du fichier en bytes
      final fileBytes = await file.readAsBytes();

      // Téléversement sur Supabase (mode anonyme)
      final _ = await _supabaseClient.storage
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
      final String publicUrl = _supabaseClient.storage
          .from(_bucketName)
          .getPublicUrl(filePath);

      print('✅ Fichier téléversé sur Supabase: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Erreur lors du téléversement du fichier sur Supabase: $e');
      return null;
    }
  }
  
  // Méthode pour assainir les noms de fichiers
  String _sanitizeFileName(String fileName) {
    // Remplacer les espaces par des underscores
    String sanitized = fileName.replaceAll(' ', '_');
    
    // Supprimer les caractères spéciaux qui pourraient causer des problèmes
    sanitized = sanitized.replaceAll(RegExp(r'[^\w\s\.-]'), '');
    
    // S'assurer que le nom ne commence pas par un point ou un tiret
    if (sanitized.startsWith('.') || sanitized.startsWith('-')) {
      sanitized = 'f$sanitized';
    }
    
    // Si le nom devient vide après nettoyage, utiliser un nom par défaut
    if (sanitized.isEmpty) {
      sanitized = 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
    
    return sanitized;
  }

  // Téléverser plusieurs fichiers
  Future<List<String>> uploadMultipleFiles(
    List<File> files, {
    String? userId,
  }) async {
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

  // Méthode pour obtenir les en-têtes d'authentification
  Map<String, String> getAuthHeaders() {
    // Si vous avez un token d'authentification, vous pouvez l'inclure ici
    return {
      'apikey': _supabaseAnonKey,
      'Authorization': 'Bearer $_supabaseAnonKey',
    };
  }

  // Méthode pour télécharger un fichier depuis une URL Supabase
  Future<String?> downloadFile(String fileUrl) async {
    try {
      // Obtenir une URL signée pour accéder au fichier
      final signedUrl = await getPublicUrl(fileUrl);
      
      // Télécharger le fichier avec l'URL signée
      final response = await http.get(
        Uri.parse(signedUrl),
        headers: getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        // Créer un fichier temporaire
        final directory = await getTemporaryDirectory();
        final fileName = basename(Uri.parse(fileUrl).path);
        final filePath = join(directory.path, fileName);

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      } else {
        print(
          'Erreur de téléchargement: ${response.statusCode} - ${response.reasonPhrase}',
        );
        return null;
      }
    } catch (e) {
      print('Exception lors du téléchargement: $e');
      return null;
    }
  }

  // Obtenir l'URL publique avec token d'accès
  Future<String> getPublicUrl(String url) async {
    try {
      // Analyser l'URL pour extraire le bucket et le chemin du fichier
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      // Format attendu: /storage/v1/object/public/[bucket]/[file_path]
      if (pathSegments.length >= 5 && pathSegments[0] == 'storage' && 
          pathSegments[1] == 'v1' && pathSegments[2] == 'object' && 
          pathSegments[3] == 'public') {
        
        final bucket = pathSegments[4];
        final filePath = pathSegments.sublist(5).join('/');
        
        // Générer une URL signée qui expire après 1 heure
        final response = await _supabaseClient
            .storage
            .from(bucket)
            .createSignedUrl(filePath, 3600); // 3600 secondes = 1 heure
        
        return response;
      } else {
        // Si le format n'est pas reconnu, retourner l'URL d'origine
        return url;
      }
    } catch (e) {
      print('Erreur lors de la génération d\'URL signée: $e');
      return url;
    }
  }
}
