import './memory_mode.dart';
import 'dart:math';

class MultiplyMode extends MemoryMode {
  @override
  String get title => 'Multiplicación';

  @override
  String get image => 'assets/images/multiply.png';

  final Random _random = Random();

  @override
  List<String> generateItems(int pairCount) {
    final Set<String> items = {};

    while (items.length < pairCount) {
      final a = _random.nextInt(9) + 1; // 1..9
      final b = _random.nextInt(9) + 1; // 1..9

      items.add('$a x $b = ${a * b}');
    }

    return items.toList();
  }
}
