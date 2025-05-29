import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../models/justification.dart';

class JustificationService {
  final String baseUrl = "http://10.0.2.2:8000/api/justifications";

  Future<bool> envoyerJustification({
    required Justification justification,
    required File? fichier,
  }) async {
    var uri = Uri.parse(baseUrl);
    var request = http.MultipartRequest('POST', uri);

    request.fields['description'] = justification.description;
    request.fields['absenceId'] = justification.absenceId ?? '';
    request.fields['adminId'] = justification.adminId ?? '';
    request.fields['statut'] = justification.statut.toString().split('.').last;

    if (fichier != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'document', // champ attendu par l'API
        fichier.path,
        filename: basename(fichier.path),
      ));
    }

    var response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
