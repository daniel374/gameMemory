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

  /// 🧠 BD
  List<String> knownPlayers = [];

  /// 👥 selección
  final List<String> selectedPlayers = [];
  final List<TextEditingController> newPlayerControllers = [];

  final Map<int, String?> errors = {};

  @override
  void initState() {
    super.initState();
    _loadPlayers();
    _syncControllers();
  }

  Future<void> _loadPlayers() async {
    final players = await GameDatabase.getPlayerNames();
    setState(() => knownPlayers = players);
  }

  void _syncControllers() {
    final needed = playerCount - selectedPlayers.length;
    newPlayerControllers
      ..clear()
      ..addAll(List.generate(needed, (_) => TextEditingController()));
    errors.clear();
  }

  void _updatePlayerCount(int count) {
    setState(() {
      playerCount = count;

      if (selectedPlayers.length > playerCount) {
        selectedPlayers.removeRange(playerCount, selectedPlayers.length);
      }

      _syncControllers();
    });
  }

  String? _validateName(String value, int index) {
    final name = value.trim();

    if (name.isEmpty) return 'Nombre requerido';
    if (name.length < 2) return 'Mínimo 2 caracteres';

    final lower = name.toLowerCase();

    /// duplicado con seleccionados
    if (selectedPlayers.map((e) => e.toLowerCase()).contains(lower)) {
      return 'Jugador ya seleccionado';
    }

    /// duplicado entre nuevos
    for (int i = 0; i < newPlayerControllers.length; i++) {
      if (i == index) continue;
      if (newPlayerControllers[i].text.trim().toLowerCase() == lower) {
        return 'Nombre duplicado';
      }
    }

    /// duplicado en BD
    if (knownPlayers.map((e) => e.toLowerCase()).contains(lower)) {
      return 'Jugador ya registrado (selecciónalo arriba)';
    }

    return null;
  }

  bool get _canStart {
    final total = selectedPlayers.length + newPlayerControllers.length;

    if (total != playerCount) return false;

    for (int i = 0; i < newPlayerControllers.length; i++) {
      final error = _validateName(newPlayerControllers[i].text, i);
      if (error != null) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(title: const Text('Selecciona jugadores')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              onChanged: (v) => _updatePlayerCount(v.toInt()),
            ),

            const SizedBox(height: 30),

            /// 🧠 REGISTRADOS
            if (knownPlayers.isNotEmpty) ...[
              const Text(
                'Jugadores registrados',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: knownPlayers.map((name) {
                  final selected = selectedPlayers.contains(name);
                  final disabled =
                      !selected && selectedPlayers.length >= playerCount;

                  return FilterChip(
                    label: Text(name),
                    selected: selected,
                    onSelected: disabled
                        ? null
                        : (v) {
                            setState(() {
                              v
                                  ? selectedPlayers.add(name)
                                  : selectedPlayers.remove(name);
                              _syncControllers();
                            });
                          },
                    selectedColor: Colors.green.shade300,
                    avatar: const Icon(Icons.person),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),
            ],

            /// ✏️ NUEVOS
            if (newPlayerControllers.isNotEmpty) ...[
              const Text(
                'Jugadores nuevos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Column(
                children: List.generate(newPlayerControllers.length, (i) {
                  final controller = newPlayerControllers[i];
                  final error = _validateName(controller.text, i);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: controller,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Jugador ${selectedPlayers.length + i + 1}',
                        prefixIcon: Icon(
                          error == null ? Icons.check_circle : Icons.error,
                          color: error == null ? Colors.green : Colors.red,
                        ),
                        errorText: error,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }),
              ),
            ],

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _canStart ? _startGame : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(260, 70),
                  textStyle: const TextStyle(fontSize: 24),
                ),
                child: const Text('Iniciar juego'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startGame() async {
    final players = <Player>[];

    for (final name in selectedPlayers) {
      players.add(Player(name: name));
    }

    for (final controller in newPlayerControllers) {
      final name = controller.text.trim();
      players.add(Player(name: name));
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
