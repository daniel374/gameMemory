import '../models/game_level.dart';
import '../models/memory_card.dart';

class MemoryGameController {
  final GameLevel level;
  late List<MemoryCard> cards;

  MemoryCard? _firstCard;
  bool _busy = false;

  MemoryGameController(this.level) {
    _initGame();
  }

  void _initGame() {
    final values = [
      '🐶',
      '🐱',
      '🦁',
      '🐸',
      '🐵',
      '🐼',
      '🐰',
      '🐯',
    ].take(level.pairCount).toList();

    cards = [...values, ...values].map((e) => MemoryCard(value: e)).toList()
      ..shuffle();
  }

  Future<void> flipCard(
    MemoryCard card,
    void Function() refresh,
    void Function() onWin,
  ) async {
    if (_busy || card.isFlipped || card.isMatched) return;

    card.isFlipped = true;
    refresh();

    if (_firstCard == null) {
      _firstCard = card;
      return;
    }

    _busy = true;

    if (_firstCard!.value == card.value) {
      _firstCard!.isMatched = true;
      card.isMatched = true;
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _firstCard!.isFlipped = false;
      card.isFlipped = false;
    }

    _firstCard = null;
    _busy = false;
    refresh();

    if (isCompleted) {
      onWin();
    }
  }

  bool get isCompleted => cards.every((card) => card.isMatched);
}
