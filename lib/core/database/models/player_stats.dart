import 'package:hive/hive.dart';

part 'player_stats.g.dart';

@HiveType(typeId: 1)
class PlayerStats extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  int wins;

  PlayerStats({required this.name, this.wins = 0});

  Map<String, dynamic> toMap() => {'name': name, 'wins': wins};

  factory PlayerStats.fromMap(Map map) {
    return PlayerStats(name: map['name'], wins: map['wins']);
  }
}
