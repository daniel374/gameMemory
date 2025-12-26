import '../models/player.dart';

class GameResult {
  final bool isDraw;
  final Player? winner;
  final List<Player> tiedPlayers;

  GameResult({required this.isDraw, this.winner, this.tiedPlayers = const []});
}
