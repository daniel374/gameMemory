import 'package:flutter/material.dart';
import '../logic/memory_game_controller.dart';
import 'memory_card_widget.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  late MemoryGameController controller;

  @override
  void initState() {
    super.initState();
    controller = MemoryGameController(['🐶', '🐱', '🦁', '🐸', '🐵', '🐼']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Juego de Memoria')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, i) => MemoryCardWidget(
          card: controller.cards[i],
          onTap: () =>
              controller.flipCard(controller.cards[i], () => setState(() {})),
        ),
      ),
    );
  }
}
