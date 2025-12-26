import 'package:hive/hive.dart';
import './models/single_score.dart';
import './models/player_stats.dart';

class GameDatabase {
  static const String singleBox = 'single_scores';
  static const String playerBox = 'player_stats';

  /// 🔹 SINGLE PLAYER – GUARDAR SCORE
  static Future<void> saveSingleScore(SingleScore score) async {
    final box = Hive.box<SingleScore>(singleBox);

    final scores = box.values.where((s) => s.mode == score.mode).toList();
    scores.add(score);

    scores.sort((a, b) => a.attempts.compareTo(b.attempts));
    final topScores = scores.take(3).toList();

    final keysToDelete = box.keys.where((key) {
      final s = box.get(key);
      return s?.mode == score.mode;
    }).toList();

    await box.deleteAll(keysToDelete);

    for (final s in topScores) {
      await box.add(s);
    }
  }

  /// 🔹 SINGLE PLAYER – OBTENER TOP 3
  static Future<List<SingleScore>> getTopSingleScores(String mode) async {
    final box = Hive.box<SingleScore>(singleBox);

    final scores = box.values.where((s) => s.mode == mode).toList();
    scores.sort((a, b) => a.attempts.compareTo(b.attempts));

    return scores.take(3).toList();
  }

  /// 🔹 REGISTRAR JUGADOR
  static Future<void> registerPlayer(String name) async {
    final box = Hive.box<PlayerStats>(playerBox);

    if (!box.values.any((p) => p.name == name)) {
      await box.add(PlayerStats(name: name));
    }
  }

  /// 🔹 REGISTRAR VICTORIA MULTIPLAYER
  static Future<void> registerWin(String playerName) async {
    final box = Hive.box<PlayerStats>(playerBox);

    PlayerStats player;

    try {
      player = box.values.firstWhere((p) => p.name == playerName);
    } catch (_) {
      player = PlayerStats(name: playerName);
      await box.add(player);
    }

    player.wins++;
    await player.save();
  }

  /// 🔹 TOP MULTIPLAYER ✅
  static Future<List<PlayerStats>> getTopPlayers({int limit = 5}) async {
    final box = Hive.box<PlayerStats>(playerBox);

    final players = box.values.toList();
    players.sort((a, b) => b.wins.compareTo(a.wins));

    return players.take(limit).toList();
  }

  /// 🔹 AUTOCOMPLETE
  static Future<List<String>> getPlayerNames() async {
    final box = Hive.box<PlayerStats>(playerBox);
    return box.values.map((p) => p.name).toSet().toList();
  }
}
