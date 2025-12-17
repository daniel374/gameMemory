import '../models/memory_mode.dart';
import '../models/game_level.dart';
import '../models/card_mode.dart';

enum FlipResult { none, correct, wrong, win }

class MemoryGameController {
  final GameLevel level;
  final MemoryMode mode;

  late List<MemoryCard> cards;
  int attempts = 0;

  MemoryCard? _firstCard;
  bool _busy = false;

  MemoryGameController({required this.level, required this.mode}) {
    _initGame();
  }

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
      result = isCompleted ? FlipResult.win : FlipResult.correct;
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _firstCard!.isFlipped = false;
      card.isFlipped = false;
      result = FlipResult.wrong;
    }

    _firstCard = null;
    _busy = false;
    refresh();

    return result;
  }

  bool get isCompleted => cards.every((card) => card.isMatched);
}
