import 'package:flutter/material.dart';
import '../models/animals_mode.dart';
import '../models/letters_mode.dart';
import '../models/numbers_mode.dart';
import '../models/memory_mode.dart';
import '../../../widgets/center_menu.dart';
import 'level_selection_page.dart';

class ModeSelectionPage extends StatelessWidget {
  const ModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modes = <MemoryMode>[AnimalsMode(), LettersMode(), NumbersMode()];

    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(title: const Text('Elige un modo')),
      body: CenterMenu(
        imagePath: 'assets/images/memory.png',
        buttons: modes.map((mode) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(240, 65),
              textStyle: const TextStyle(fontSize: 24),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LevelSelectionPage(mode: mode),
                ),
              );
            },
            child: Text(mode.title),
          );
        }).toList(),
      ),
    );
  }
}
