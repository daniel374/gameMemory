import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCorrect() async {
    await _player.play(AssetSource('sounds/correct.mp3'));
  }

  static Future<void> playWrong() async {
    await _player.play(AssetSource('sounds/wrong.mp3'));
  }

  static Future<void> playWin() async {
    await _player.play(AssetSource('sounds/win.mp3'));
  }
}
