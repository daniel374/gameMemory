import 'package:flutter/material.dart';
import '../logic/memory_game_controller.dart';
import '../models/game_level.dart';
import 'memory_card_widget.dart';
import '../../../utils/sound_player.dart';

class MemoryGamePage extends StatefulWidget {
  final GameLevel level;
  const MemoryGamePage({super.key, required this.level});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  late MemoryGameController controller;

  @override
  void initState() {
    super.initState();
    controller = MemoryGameController(widget.level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Juego de Memoria')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Intentos: ${controller.attempts}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) => MemoryCardWidget(
                card: controller.cards[i],
                onTap: () async {
                  final result = await controller.flipCard(
                    controller.cards[i],
                    () => setState(() {}),
                  );

                  switch (result) {
                    case FlipResult.correct:
                      SoundService.playCorrect();
                      break;
                    case FlipResult.wrong:
                      SoundService.playWrong();
                      break;
                    case FlipResult.win:
                      SoundService.playWin();
                      _showWinDialog();
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('🎉 ¡Muy bien!'),
        content: Text(
          'Ganaste en ${controller.attempts} intentos 💪',
          style: const TextStyle(fontSize: 22),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }
}
