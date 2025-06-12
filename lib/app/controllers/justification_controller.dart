import 'package:front_mobile_gestion_absence_ism/app/data/services/api_service.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:front_mobile_gestion_absence_ism/app/utils/helpers/snackbar_utils.dart';

// Importer le service de fichier mis à jour
import '../data/services/file_service.dart';

class JustificationController extends GetxController {
  // Services - Pas utilisé directement dans le mode mock

  // Variables pour la justification
  final description = ''.obs;
  final absenceId = ''.obs;
  final isSubmitting = false.obs;
  final isServerConnected = true.obs;
  final RxList<File> selectedFiles = <File>[].obs;

  final FileService _fileService = Get.find<FileService>();
  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    // Récupérer l'ID de l'absence depuis les arguments si disponible
    final Map<String, dynamic>? args = Get.arguments;
    if (args != null && args['id'] != null) {
      absenceId.value = args['id'].toString();
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Vérifier la connexion au serveur
    _checkServerConnection();
  }

  @override
  void onClose() {
    // Nettoyer les ressources
    description.value = '';
    selectedFiles.clear();
    super.onClose();
  }

  // Méthode privée pour vérifier la connexion au serveur
  Future<bool> _checkServerConnection() async {
    try {
      // Par exemple, faire une requête ping vers le serveur
      await Future.delayed(const Duration(milliseconds: 500));

      // Pour démonstration, on retourne true (connecté)
      isServerConnected.value = true;
      return true;
    } catch (e) {
      print('Erreur de connexion au serveur: $e');
      isServerConnected.value = false;
      return false;
    }
  }

  // Méthode pour prendre une photo via la caméra
  Future<void> pickFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Compression de l'image pour optimiser la taille
        maxWidth: 1280, // Largeur maximale de l'image
        maxHeight: 1280, // Hauteur maximale de l'image
      );

      if (photo != null) {
        selectedFiles.add(File(photo.path));
        print('✅ Photo prise depuis la caméra: ${photo.path}');
      }
    } catch (e) {
      print('❌ Erreur lors de la prise de photo: $e');
      SnackbarUtils.showError(
        'Erreur',
        'Impossible de prendre une photo. Veuillez réessayer.',
      );
    }
  }

  // Méthode pour sélectionner plusieurs images de la galerie
  Future<void> pickImagesFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1280,
        maxHeight: 1280,
      );

      if (images.isNotEmpty) {
        for (var image in images) {
          selectedFiles.add(File(image.path));
        }
        print('✅ ${images.length} images sélectionnées depuis la galerie');
      }
    } catch (e) {
      print('❌ Erreur lors de la sélection d\'images: $e');
      SnackbarUtils.showError(
        'Erreur',
        'Impossible de sélectionner les images. Veuillez réessayer.',
      );
    }
  }

  // Méthode pour sélectionner plusieurs documents
  Future<void> pickMultipleFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'xls', 'xlsx'],
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.path != null) {
            selectedFiles.add(File(file.path!));
          }
        }
        print('✅ ${result.files.length} documents sélectionnés');
      }
    } catch (e) {
      print('❌ Erreur lors de la sélection des documents: $e');
      SnackbarUtils.showError(
        'Erreur',
        'Impossible de sélectionner les documents. Veuillez réessayer.',
      );
    }
  }

  // Méthode pour supprimer un fichier de la liste
  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  // Méthode pour envoyer la justification avec plusieurs fichiers
  Future<bool> envoyerJustification() async {
    try {
      isSubmitting.value = true;

      if (description.value.isEmpty) {
        SnackbarUtils.showError(
          'Erreur',
          'Veuillez saisir une description pour votre justification',
        );
        return false;
      }

      // 1. Téléverser les fichiers sur Supabase
      List<String> pieceJointeUrls = [];
      if (selectedFiles.isNotEmpty) {
        pieceJointeUrls = await _fileService.uploadMultipleFiles(selectedFiles);
        
        if (pieceJointeUrls.isEmpty && selectedFiles.isNotEmpty) {
          SnackbarUtils.showError(
            'Erreur',
            'Impossible de téléverser les pièces jointes. Veuillez réessayer.',
          );
          return false;
        }
      }

      // 2. Envoyer les données à votre API MongoDB (avec les URLs Supabase)
      final justificationData = {
        'absenceId': absenceId.value,
        'description': description.value,
        'piecesJointes': pieceJointeUrls, // URLs des fichiers Supabase
      };

      // Votre API existante sauvegarde ces données dans MongoDB
      final response = await _apiService.post('etudiant/justification', justificationData);
      
      if (response != null) {
        SnackbarUtils.showSuccess(
          'Succès',
          'Votre justification a été envoyée avec succès',
        );
        
        // Réinitialiser les champs
        description.value = '';
        selectedFiles.clear();
        
        return true;
      } else {
        SnackbarUtils.showError(
          'Erreur',
          'Une erreur est survenue lors de l\'envoi de votre justification',
        );
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la justification: $e');
      SnackbarUtils.showError('Erreur', 'Une erreur est survenue: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}

// Classe fictive pour simuler un fichier
class DummyFile {
  final String path;

  DummyFile(this.path);
}
