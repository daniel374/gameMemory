import 'package:hive/hive.dart';

part 'player_stats.g.dart';

@HiveType(typeId: 1)
class PlayerStats extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  int wins;

  @HiveField(2)
  int gamesPlayed;

  PlayerStats({required this.name, this.wins = 0, this.gamesPlayed = 0});

  /// 🎮 se llama siempre que juega
  void addGame() {
    gamesPlayed++;
    save();
  }

  /// 🏆 se llama SOLO si gana
  void addWin() {
    wins++;
    save();
  }
}
