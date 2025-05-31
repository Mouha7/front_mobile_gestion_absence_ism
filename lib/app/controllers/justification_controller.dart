import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:front_mobile_gestion_absence_ism/app/utils/helpers/snackbar_utils.dart';

class JustificationController extends GetxController {
  // Services - Pas utilisé directement dans le mode mock

  // Variables pour la justification
  final description = ''.obs;
  final absenceId = ''.obs;
  final isSubmitting = false.obs;
  final isServerConnected = true.obs;
  final Rx<dynamic> selectedFile = Rx<dynamic>(null);

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
    selectedFile.value = null;
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
        selectedFile.value = File(photo.path);
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

  // Méthode pour sélectionner un document depuis l'appareil
  Future<void> pickFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFile.value = File(result.files.single.path!);
        print('✅ Document sélectionné: ${result.files.single.path}');
      }
    } catch (e) {
      print('❌ Erreur lors de la sélection du document: $e');
      SnackbarUtils.showError(
        'Erreur',
        'Impossible de sélectionner le document. Veuillez réessayer.',
      );
    }
  }

  // Méthode pour envoyer une justification
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

      // Simuler un délai réseau
      await Future.delayed(const Duration(milliseconds: 1500));

      // Vérifier la connexion au serveur
      if (!isServerConnected.value) {
        SnackbarUtils.showError(
          'Erreur',
          'Impossible de soumettre la justification. Vérifiez votre connexion internet.',
        );
        return false;
      }

      // Simuler l'envoi de la pièce jointe
      String? pieceJointeUrl;
      if (selectedFile.value != null) {
        // Simuler l'upload du fichier
        await Future.delayed(const Duration(milliseconds: 500));
        pieceJointeUrl =
            'https://mock-server.com/files/${DateTime.now().millisecondsSinceEpoch}';
        print('✅ Pièce jointe téléchargée vers: $pieceJointeUrl');
      }

      // Simuler l'envoi de la justification
      final mockJustification = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'absenceId': absenceId.value,
        'description': description.value,
        'pieceJointe': pieceJointeUrl,
        'dateCreation': DateTime.now().toIso8601String(),
        'statut': 'En attente',
      };

      print('✅ Justification simulée envoyée: ${mockJustification.toString()}');

      // Simuler une réponse réussie
      SnackbarUtils.showSuccess(
        'Succès',
        'Votre justification a été envoyée avec succès',
      );

      // Réinitialiser les champs
      description.value = '';
      selectedFile.value = null;

      // Retourner à l'écran précédent après un court délai
      await Future.delayed(const Duration(seconds: 1));
      Get.back(result: true);

      return true;
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
