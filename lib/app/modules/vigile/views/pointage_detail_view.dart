import 'package:flutter/material.dart';
import '../../../data/models/pointage.dart';

class PointageDetailView extends StatelessWidget {
  final Pointage pointage;

  const PointageDetailView({super.key, required this.pointage});

  Color get brown => const Color(0xFF7A4B27);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brown,
      appBar: AppBar(
        title: const Text('Détail du pointage'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.home, color: Color(0xFF7A4B27)),
                  const SizedBox(width: 10),
                  Text(pointage.matiere, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.group, color: Color(0xFF7A4B27)),
                  const SizedBox(width: 8),
                  Text('Classe : ${pointage.classe}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF7A4B27)),
                  const SizedBox(width: 8),
                  Text('Date : ${pointage.date}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Color(0xFF7A4B27)),
                  const SizedBox(width: 8),
                  Text('Heure : ${pointage.heure}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              if (pointage.salle != null && pointage.salle!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF7A4B27)),
                    const SizedBox(width: 8),
                    Text('Salle : ${pointage.salle}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}