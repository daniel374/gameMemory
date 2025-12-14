import 'package:flutter/material.dart';
import '../models/game_level.dart';
import 'memory_game_page.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(title: const Text('Elige un nivel')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: GameLevel.values.map((level) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
                textStyle: const TextStyle(fontSize: 22),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MemoryGamePage(level: level),
                  ),
                );
              },
              child: Text(level.title),
            ),
          );
        }).toList(),
      ),
    );
  }
}
