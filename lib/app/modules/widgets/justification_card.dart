import 'package:flutter/material.dart';

class JustificationCard extends StatelessWidget {
  final String nom;
  final String prenom;
  final String classe;
  final String faute;
  final String description;

  const JustificationCard({
    super.key,
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.faute,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFFFF8F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLine("Nom", nom),
            _buildLine("Prénom", prenom),
            _buildLine("Classe", classe),
            _buildLine("Faute", faute),
            const SizedBox(height: 12),
            const Text("Justification :", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text("$label : ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
