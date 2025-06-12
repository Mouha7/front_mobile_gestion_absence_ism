import 'dart:io';
import 'package:front_mobile_gestion_absence_ism/app/data/services/supabase_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'storage_service.dart'; 

class FileService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final SupabaseStorageService _supabaseService = Get.find<SupabaseStorageService>();
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
  
  // Téléverser un fichier sur Supabase et renvoyer l'URL
  Future<String?> uploadFile(File file) async {
    // Récupérer l'ID utilisateur depuis le stockage local
    final userData = _storageService.getUser();
    final String userId = userData?['id']?.toString() ?? '';
    
    // Téléverser sur Supabase
    return await _supabaseService.uploadFile(file, userId: userId);
  }
  
  // Téléverser plusieurs fichiers et obtenir leurs URLs
  Future<List<String>> uploadMultipleFiles(List<File> files) async {
    // Récupérer l'ID utilisateur depuis le stockage local
    final userData = _storageService.getUser();
    final String userId = userData?['id']?.toString() ?? '';
    
    // Téléverser sur Supabase
    return await _supabaseService.uploadMultipleFiles(files, userId: userId);
  }
}