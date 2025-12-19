import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../models/memory_mode.dart';
import '../../../widgets/center_menu.dart';
import 'player_selection_page.dart';
import '../../../core/asset_cache.dart';



class LevelSelectionPage extends StatelessWidget {
  final MemoryMode mode;

  const LevelSelectionPage({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(title: Text('Elige un ${mode.title}')),
      body: CenterMenu(
        imagePath: mode.image,
        buttons: GameLevel.values.map((level) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(240, 65),
              textStyle: const TextStyle(fontSize: 24),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerSelectionPage(level: level, mode: mode),
                ),
              );
            },
            child: Text(level.title),
          );
        }).toList(),
      ),
    );
  }
}
