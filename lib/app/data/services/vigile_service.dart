import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/vigile.dart';

class VigileService extends GetxService {
  final String baseUrl = 'https:///api';

  Future<Vigile> getVigileProfile(String vigileId) async {
    final url = Uri.parse('$baseUrl/vigile/$vigileId');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(res.body);
      return Vigile.fromJson(data);
    } else {
      throw Exception('Impossible de charger le profil');
    }
  }
}