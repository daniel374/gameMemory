import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/memory_mode.dart';
import '../models/game_level.dart';
import '../../../core/database/game_database.dart';
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
  late List<TextEditingController> controllers;

  /// 🧠 nombres guardados en Hive
  List<String> knownPlayers = [];
  List<bool> isExistingPlayer = [];


  @override
  void initState() {
    super.initState();
    controllers = List.generate(playerCount, (_) => TextEditingController());
    isExistingPlayer = List.generate(playerCount, (_) => false);
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final players = await GameDatabase.getPlayerNames();
    setState(() {
      knownPlayers = players;
    });
  }

  void _updateControllers(int newCount) {
    setState(() {
      playerCount = newCount;
      controllers = List.generate(
        playerCount,
        (i) =>
            i < controllers.length ? controllers[i] : TextEditingController(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(title: const Text('Selecciona jugadores')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

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
              onChanged: (value) => _updateControllers(value.toInt()),
            ),

            Text(
              '$playerCount jugadores',
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 30),

            /// 👥 INPUTS DE JUGADORES
            Column(
              children: List.generate(playerCount, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Autocomplete<String>(
                    optionsBuilder: (text) {
                      if (text.text.isEmpty)
                        return const Iterable<String>.empty();

                      return knownPlayers.where(
                        (name) => name.toLowerCase().contains(
                          text.text.toLowerCase(),
                        ),
                      );
                    },
                    onSelected: (value) {
                      controllers[i].text = value;
                    },
                    fieldViewBuilder:
                        (context, textController, focusNode, onFieldSubmitted) {
                          return TextField(
                            controller: controllers[i], // 👈 CLAVE
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'Jugador ${i + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          );
                        },
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            /// ▶️ INICIAR JUEGO
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(260, 70),
                textStyle: const TextStyle(fontSize: 24),
              ),
              onPressed: _startGame,
              child: const Text('Iniciar juego'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startGame() async {
    final players = <Player>[];

    for (int i = 0; i < playerCount; i++) {
      final name = controllers[i].text.trim().isEmpty
          ? 'Jugador ${i + 1}'
          : controllers[i].text.trim();

      players.add(Player(name: name));

      /// 💾 Guardar jugador en BD
      await GameDatabase.registerPlayer(name);
    }

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
  }
}
