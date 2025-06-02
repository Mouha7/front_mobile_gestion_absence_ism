// Formateur de dates
import 'package:intl/intl.dart';

/// Classe utilitaire pour formatter les dates et heures
class DateFormatter {
  /// Formate une date ISO (YYYY-MM-DD) en format localisé (DD/MM/YYYY)
  static String formatDate(String isoDate) {
    try {
      final DateTime date = DateTime.parse(isoDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  /// Formate l'heure (HH:MM) pour l'affichage
  static String formatTime(String dateTimeString) {
    try {
      if (dateTimeString.isEmpty) return 'Non spécifiée';

      // Format ISO avec T
      if (dateTimeString.contains('T')) {
        final parts = dateTimeString.split('T');
        if (parts.length > 1) {
          // Prendre juste HH:MM de la partie heure
          return parts[1].substring(0, 5);
        }
      }

      // Format avec :
      if (dateTimeString.contains(':')) {
        return dateTimeString.split(':').take(2).join(':');
      }

      return dateTimeString;
    } catch (e) {
      print('Erreur dans formatTime: $e');
      return 'Format invalide';
    }
  }

  /// Retourne la date du jour au format ISO (YYYY-MM-DD)
  static String today() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  /// Retourne la date et l'heure actuelles au format ISO (YYYY-MM-DD HH:MM:SS)
  static String now() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  /// Calcule la durée entre deux heures au format HH:MM
  static String calculateDuration(String startTime, String endTime) {
    try {
      // Convertir les heures en minutes
      List<String> startParts = startTime.split(':');
      List<String> endParts = endTime.split(':');

      int startMinutes =
          int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      int endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      // Calculer la différence
      int differenceMinutes = endMinutes - startMinutes;

      if (differenceMinutes < 0) {
        // Si l'heure de fin est avant l'heure de début (cas particulier)
        differenceMinutes = 0;
      }

      // Format de la durée en H:MM
      int hours = differenceMinutes ~/ 60;
      int minutes = differenceMinutes % 60;

      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00';
    }
  }

  /// Convertit une date et une heure en texte convivial (aujourd'hui, hier, etc.)
  static String timeAgo(String dateTime) {
    try {
      final DateTime dateTimeObj = DateTime.parse(dateTime);
      final DateTime now = DateTime.now();
      final difference = now.difference(dateTimeObj);

      if (difference.inDays < 1) {
        return 'Aujourd\'hui';
      } else if (difference.inDays < 2) {
        return 'Hier';
      } else if (difference.inDays < 7) {
        return 'Il y a ${difference.inDays} jours';
      } else {
        return DateFormat('dd/MM/yyyy').format(dateTimeObj);
      }
    } catch (e) {
      return dateTime;
    }
  }

  /// Récupère le jour de la semaine (Lundi, Mardi, etc.) à partir d'une date ISO
  static String getDayOfWeek(String isoDate) {
    try {
      final DateTime date = DateTime.parse(isoDate);
      final List<String> days = [
        'Lundi',
        'Mardi',
        'Mercredi',
        'Jeudi',
        'Vendredi',
        'Samedi',
        'Dimanche',
      ];
      // weekday retourne 1 pour lundi, 2 pour mardi, etc.
      return days[date.weekday - 1];
    } catch (e) {
      return '';
    }
  }
}
