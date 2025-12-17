import './memory_mode.dart';

class NumbersMode extends MemoryMode {
  @override
  String get title => 'Números';

  @override
  String get image => 'assets/images/numbers.png';

  @override
  List<String> generateItems(int pairCount) {
    return List.generate(pairCount, (i) => '${i + 1}');
  }
}
