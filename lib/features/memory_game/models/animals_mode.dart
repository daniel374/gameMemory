import './memory_mode.dart';

class AnimalsMode extends MemoryMode {
  @override
  String get title => 'Animales';

  @override
  String get image => 'assets/images/animals.png';

  @override
  List<String> generateItems(int pairCount) {
    const animals = ['🐶', '🐱', '🦁', '🐸', '🐵', '🐼', '🐰', '🐯'];
    return animals.take(pairCount).toList();
  }
}
