import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pointage.dart';

class PointageService extends GetxService {
  final String baseUrl = 'https://TON_BACKEND_SPRINGBOOT_URL/api';

  Future<List<Pointage>> getPointagesVigile(String vigileId) async {
    final url = Uri.parse('$baseUrl/vigile/$vigileId/pointages');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Pointage.fromJson(e)).toList();
    } else {
      throw Exception('Erreur chargement pointages');
    }
  }
}

  Future<List<Pointage>> getPointagesEtudiant(String etudiantId) async {
    final url = Uri.parse('$baseUrl/etudiant/$etudiantId/pointages');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Pointage.fromJson(e)).toList();
    } else {
      throw Exception('Erreur chargement pointages');
    }
  }
}

  