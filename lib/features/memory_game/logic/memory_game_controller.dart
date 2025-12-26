import '../models/memory_mode.dart';
import '../models/game_level.dart';
import '../models/card_mode.dart';
import '../models/player.dart';
import 'game_result.dart';

enum FlipResult { none, correct, wrong, win }

class MemoryGameController {
  final GameLevel level;
  final MemoryMode mode;
  final List<Player> players;

  late List<MemoryCard> cards;

  int currentPlayerIndex = 0;
  int attempts = 0;

  MemoryCard? _firstCard;
  bool _busy = false;

  MemoryGameController({
    required this.level,
    required this.mode,
    required this.players,
  }) {
    _initGame();
  }

  Player get currentPlayer => players[currentPlayerIndex];

  void _initGame() {
    final values = mode.generateItems(level.pairCount);

    cards = [...values, ...values].map((e) => MemoryCard(value: e)).toList()
      ..shuffle();
  }

  Future<FlipResult> flipCard(MemoryCard card, void Function() refresh) async {
    if (_busy || card.isFlipped || card.isMatched) return FlipResult.none;

    card.isFlipped = true;
    refresh();

    if (_firstCard == null) {
      _firstCard = card;
      return FlipResult.none;
    }

    _busy = true;
    attempts++; // 👈 AQUÍ CUENTA EL INTENTO

    FlipResult result;

    if (_firstCard!.value == card.value) {
      _firstCard!.isMatched = true;
      card.isMatched = true;

      currentPlayer.score++; // ⭐ SUMA PUNTO
      result = isCompleted ? FlipResult.win : FlipResult.correct;
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _firstCard!.isFlipped = false;
      card.isFlipped = false;

      _nextPlayer(); // 🔁 CAMBIA TURNO
      result = FlipResult.wrong;
    }

    _firstCard = null;
    _busy = false;
    refresh();

    return result;
  }

  void _nextPlayer() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
  }

  // ✅ Juego terminado
  bool get isCompleted => cards.every((card) => card.isMatched);

  // 🏆 GANADOR
  GameResult get gameResult {
    final maxScore = players
        .map((p) => p.score)
        .reduce((a, b) => a > b ? a : b);

    final winners = players.where((p) => p.score == maxScore).toList();

    if (winners.length > 1) {
      return GameResult(isDraw: true, tiedPlayers: winners);
    }

    return GameResult(isDraw: false, winner: winners.first);
  }
}
