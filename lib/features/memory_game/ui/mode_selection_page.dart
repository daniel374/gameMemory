import 'package:flutter/material.dart';
import 'package:test2app/core/asset_cache.dart';

import '../models/animals_mode.dart';
import '../models/letters_mode.dart';
import '../models/numbers_mode.dart';
import '../models/memory_mode.dart';

import '../../../widgets/center_menu.dart';
import 'level_selection_page.dart';
import 'rankings_page.dart';

class ModeSelectionPage extends StatelessWidget {
  const ModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modes = <MemoryMode>[AnimalsMode(), LettersMode(), NumbersMode()];

    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        title: const Text('Elige un modo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            tooltip: 'Ver Rankings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RankingsPage()),
              );
            },
          ),
        ],
      ),
      body: CenterMenu(
        imagePath: 'assets/images/memory.png',
        buttons: [
          ...modes.map((mode) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(240, 65),
                textStyle: const TextStyle(fontSize: 24),
              ),
              onPressed: () async {
                await AssetCache.preloadAsset(context, [mode.image]);

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) => LevelSelectionPage(mode: mode),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween(
                            begin: 0.95,
                            end: 1.0,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
              child: Text(mode.title),
            );
          }),

          const SizedBox(height: 20),

          // 🔥 BOTÓN DIRECTO A RANKINGS
          ElevatedButton.icon(
            icon: const Icon(Icons.emoji_events),
            label: const Text('Rankings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(240, 65),
              textStyle: const TextStyle(fontSize: 22),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RankingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
