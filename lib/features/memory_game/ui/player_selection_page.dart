import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/memory_mode.dart';
import '../models/game_level.dart';
import 'memory_game_page.dart';

class PlayerSelectionPage extends StatefulWidget {
  final MemoryMode mode;
  final GameLevel level;

  const PlayerSelectionPage({
    super.key,
    required this.mode,
    required this.level,
  });

  @override
  State<PlayerSelectionPage> createState() => _PlayerSelectionPageState();
}

class _PlayerSelectionPageState extends State<PlayerSelectionPage> {
  int playerCount = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(title: const Text('Selecciona jugadores')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Cuántos jugadores?',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Slider(
              min: 1,
              max: 4,
              divisions: 3,
              label: '$playerCount',
              value: playerCount.toDouble(),
              onChanged: (value) {
                setState(() {
                  playerCount = value.toInt();
                });
              },
            ),

            Text(
              '$playerCount jugadores',
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(240, 65),
                textStyle: const TextStyle(fontSize: 24),
              ),
              onPressed: () {
                final players = List.generate(
                  playerCount,
                  (i) => Player(name: 'Jugador ${i + 1}'),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MemoryGamePage(
                      level: widget.level,
                      mode: widget.mode,
                      players: players,
                    ),
                  ),
                );
              },
              child: const Text('Iniciar juego'),
            ),
          ],
        ),
      ),
    );
  }
}
