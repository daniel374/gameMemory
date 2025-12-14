class MemoryCard {
  final String value;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.value,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
