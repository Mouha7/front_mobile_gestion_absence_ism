import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSuccess() async {
    try {
      await _player.play(AssetSource('sounds/success.wav'));
    } catch (e) {
      print('Erreur lors de la lecture du son: $e');
    }
  }

  static Future<void> playError() async {
    try {
      await _player.play(AssetSource('sounds/error.wav'));
    } catch (e) {
      print('Erreur lors de la lecture du son: $e');
    }
  }
}
