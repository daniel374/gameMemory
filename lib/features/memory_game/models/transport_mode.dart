import './memory_mode.dart';

class TransportMode extends MemoryMode {
  @override
  String get title => 'Transporte';

  @override
  String get image => 'assets/images/transport.png';

  @override
  List<String> generateItems(int pairCount) {
    const _transport = [
      '🚗',
      '🚕',
      '🚙',
      '🚌',
      '🚎',
      '🏎️',
      '🚓',
      '🚑',
      '🚒',
      '🚐',
      '🚚',
      '🚛',
      '🚜',
      '🚲',
      '🛴',
      '🏍️',
      '🚂',
      '🚆',
      '🚊',
      '✈️',
      '🛫',
      '🚀',
      '🚁',
      '🚤',
    ]; // 24 ítems

    if (_transport.length < pairCount) {
      throw Exception(
        'Transporte insuficiente: ${_transport.length} < $pairCount',
      );
    }
    return _transport.take(pairCount).toList();
  }
}
