import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/memory_mode.dart';
import '../logic/memory_game_controller.dart';
import '../models/game_level.dart';
import 'memory_card_widget.dart';
import '../../../utils/sound_player.dart';
import '../../../utils/voice_player.dart';

class MemoryGamePage extends StatefulWidget {
  final GameLevel level;
  final MemoryMode mode;
  final List<Player> players;

  const MemoryGamePage({
    super.key,
    required this.level,
    required this.mode,
    required this.players,
  });

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  late MemoryGameController controller;

  @override
  void initState() {
    super.initState();
    controller = MemoryGameController(
      level: widget.level,
      mode: widget.mode,
      players: widget.players,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Memoria - ${widget.mode.title}')),
      body: Column(
        children: [
          _buildScoreBoard(),

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

                  _handleFlipResult(result, controller.cards[i].value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🏆 MARCADOR SUPERIOR
  Widget _buildScoreBoard() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        itemCount: controller.players.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final player = controller.players[i];
          final isTurn = i == controller.currentPlayerIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isTurn ? Colors.orange : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('⭐ ${player.score}', style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleFlipResult(FlipResult result, String value) {
    switch (result) {
      case FlipResult.correct:
        SoundService.playCorrect();
        VoicePlayer.speak(value);
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
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('🏆 Fin del juego'),
        content: Text(
          'Ganó ${controller.winner.name}\n'
          '⭐ ${controller.winner.score} puntos',
          textAlign: TextAlign.center,
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
