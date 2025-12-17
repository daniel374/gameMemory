import './memory_mode.dart';

class LettersMode extends MemoryMode {
  @override
  String get title => 'Letras';

  @override
  String get image => 'assets/images/letters.png';

  @override
  List<String> generateItems(int pairCount) {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    return letters.take(pairCount).toList();
  }
}
