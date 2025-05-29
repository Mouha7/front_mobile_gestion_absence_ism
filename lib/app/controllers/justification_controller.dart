import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/enums/statut_justification.dart';
import '../data/models/justification.dart';
import '../data/services/justification_service.dart';

class JustificationController extends GetxController {
  var description = ''.obs;
  var absenceId = ''.obs;
  var adminId = ''.obs;
  var statut = StatutJustification.EN_ATTENTE.obs;
  Rx<File?> selectedFile = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();

  void pickFromCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) selectedFile.value = File(picked.path);
  }

  void pickFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  Future<void> envoyerJustification() async {
    final justification = Justification(
      id: '', // géré côté backend
      dateCreation: DateTime.now().toIso8601String(),
      description: description.value,
      documentPath: '',
      statut: statut.value,
      absenceId: absenceId.value,
      adminId: adminId.value,
    );

    final success = await JustificationService().envoyerJustification(
      justification: justification,
      fichier: selectedFile.value,
    );

    if (success) {
      Get.snackbar('Succès', 'Justification envoyée avec succès');
    } else {
      Get.snackbar('Erreur', 'Échec de l’envoi de la justification');
    }
  }
}
