import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'storage_service.dart';

class FileService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  final ImagePicker _picker = ImagePicker();
  
  // Sélectionner une image depuis la galerie
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 80
    );
    
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
  
  // Prendre une photo avec la caméra
  Future<File?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80
    );
    
    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }
  
  // Télécharger une vidéo (pour la justification d'absence)
  Future<File?> pickVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    
    if (video != null) {
      return File(video.path);
    }
    return null;
  }
  
  // Téléverser un fichier vers le backend
  Future<String?> uploadFile(File file, String endpoint) async {
    try {
      // Créer une requête multipart
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('${_apiService.baseUrl}/$endpoint')
      );
      
      // Ajouter l'en-tête d'autorisation
      final token = _storageService.token;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      // Déterminer le type MIME
      String mimeType = 'application/octet-stream';
      String fileExtension = extension(file.path).toLowerCase();
      
      if (fileExtension == '.jpg' || fileExtension == '.jpeg') {
        mimeType = 'image/jpeg';
      } else if (fileExtension == '.png') {
        mimeType = 'image/png';
      } else if (fileExtension == '.pdf') {
        mimeType = 'application/pdf';
      } else if (fileExtension == '.mp4') {
        mimeType = 'video/mp4';
      }
      
      // Ajouter le fichier à la requête
      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();
      
      var multipartFile = http.MultipartFile(
        'file', 
        fileStream, 
        length,
        filename: basename(file.path),
        contentType: MediaType.parse(mimeType)
      );
      
      request.files.add(multipartFile);
      
      // Envoyer la requête
      var response = await request.send();
      
      // Traiter la réponse
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        // Supposons que le serveur renvoie un JSON avec l'URL du fichier uploadé
        Map<String, dynamic> data = jsonDecode(responseData);
        return data['fileUrl'] as String?;
      } else {
        throw Exception('Échec de téléversement: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors du téléversement: $e');
      return null;
    }
  }
  
  // Télécharger un fichier depuis le backend
  Future<File?> downloadFile(String fileUrl, String filename) async {
    try {
      // Obtenir le répertoire temporaire
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$filename';
      
      // Télécharger le fichier
      final response = await http.get(Uri.parse(fileUrl));
      
      if (response.statusCode == 200) {
        // Écrire le fichier
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Échec de téléchargement: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors du téléchargement: $e');
      return null;
    }
  }
}