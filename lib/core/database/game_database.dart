import 'package:hive/hive.dart';
import './models/single_score.dart';
import './models/player_stats.dart';

class GameDatabase {
  static const String singleBox = 'single_scores';
  static const String playerBox = 'player_stats';

  /// 🔹 SINGLE PLAYER – GUARDAR SCORE
  static Future<void> saveSingleScore(SingleScore score) async {
    final box = Hive.box<SingleScore>(singleBox);

    // Filtrar scores del mismo modo + categoría + nivel
    final scores = box.values
        .where(
          (s) =>
              s.mode == score.mode &&
              s.category == score.category &&
              s.level == score.level,
        )
        .toList();

    scores.add(score);

    // Ordenar por menor cantidad de intentos
    scores.sort((a, b) => a.attempts.compareTo(b.attempts));
    final topScores = scores.take(3).toList();

    // Limpiar scores antiguos de ese modo + categoría + nivel
    final keysToDelete = box.keys.where((key) {
      final s = box.get(key);
      return s?.mode == score.mode &&
          s?.category == score.category &&
          s?.level == score.level;
    }).toList();

    await box.deleteAll(keysToDelete);

    // Guardar top 3
    for (final s in topScores) {
      await box.add(s);
    }
  }

  /// 🔹 SINGLE PLAYER – OBTENER TOP 3
  /// 🔹 Obtener top single scores filtrado por categoría y nivel
  static Future<List<SingleScore>> getTopSingleScores(
    String mode, {
    String? category,
    String? level,
  }) async {
    final box = Hive.box<SingleScore>(singleBox);

    var scores = box.values.where((s) => s.mode == mode).toList();

    if (category != null) {
      scores = scores.where((s) => s.category == category).toList();
    }

    if (level != null) {
      scores = scores.where((s) => s.level == level).toList();
    }

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
      // Si no existe, crear jugador
      player = PlayerStats(name: playerName);
      await box.add(player);
    }

    // Incrementar victorias
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

  /// 🔹 AUTOCOMPLETE NOMBRES
  static Future<List<String>> getPlayerNames() async {
    final box = Hive.box<PlayerStats>(playerBox);
    return box.values.map((p) => p.name).toSet().toList();
  }

  /// 🔹 TODOS LOS JUGADORES CON SUS ESTADÍSTICAS
  static Future<List<PlayerStats>> getAllPlayersWithStats() async {
    final players = await getPlayerNames();
    final stats = await getTopPlayers();
    final statsMap = {for (final s in stats) s.name.toLowerCase(): s};

    return players.map((name) {
      final stat = statsMap[name.toLowerCase()];
      return PlayerStats(name: name, wins: stat?.wins ?? 0);
    }).toList()..sort((a, b) => b.wins.compareTo(a.wins));
  }
}
