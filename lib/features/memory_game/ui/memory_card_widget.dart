import 'package:flutter/material.dart';
import '../models/card_mode.dart';

class MemoryCardWidget extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;

  const MemoryCardWidget({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched
              ? Colors.white
              : Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            card.isFlipped || card.isMatched ? card.value : '❓',
            style: const TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}
