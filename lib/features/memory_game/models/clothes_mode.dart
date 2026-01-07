import './memory_mode.dart';

class ClothesMode extends MemoryMode {
  @override
  String get title => 'Ropa';

  @override
  String get image => 'assets/images/clothes.png';

  @override
  List<String> generateItems(int pairCount) {
    const List<String> _clothes = [
      '👕',
      '👖',
      '👗',
      '👔',
      '👚',
      '🧥',
      '🧦',
      '👟',
      '👞',
      '👠',
      '👡',
      '👢',
      '🎩',
      '🧢',
      '👒',
      '🧣',
      '🧤',
      '🧦',
      '🥼',
      '🩳',
      '🩱',
      '🩲',
      '👙',
      '🥻',
    ];
    return _clothes.take(pairCount).toList();
  }
}
