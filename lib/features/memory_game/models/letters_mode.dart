import './memory_mode.dart';

class LettersMode extends MemoryMode {
  @override
  String get title => 'Letras';

  @override
  String get image => 'assets/images/letters.png';

  @override
  List<String> generateItems(int pairCount) {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H','I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
    return letters.take(pairCount).toList();
  }
}
