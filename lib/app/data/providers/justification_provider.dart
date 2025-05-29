import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../models/justification.dart';

class JustificationProvider {
  final String baseUrl = "http://10.0.2.2:8000/api/justifications";

  Future<bool> envoyerJustification({
    required Justification justification,
    required File? fichier,
  }) async {
    try {
      var uri = Uri.parse(baseUrl);
      var request = http.MultipartRequest('POST', uri);

      // Champs standards
      request.fields['description'] = justification.description;
      request.fields['absenceId'] = justification.absenceId ?? '';
      request.fields['adminId'] = justification.adminId ?? '';
      request.fields['statut'] = justification.statut.toString().split('.').last;

      // Fichier joint
      if (fichier != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'document', // Nom du champ attendu par l'API
          fichier.path,
          filename: basename(fichier.path),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Erreur lors de l'envoi de la justification: $e");
      return false;
    }
  }
}
