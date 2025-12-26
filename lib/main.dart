import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/memory_game/ui/mode_selection_page.dart';
import 'core/database/models/player_stats.dart';
import 'core/database/models/single_score.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // 🔐 Registrar adapters de Hive
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(PlayerStatsAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(SingleScoreAdapter());
  }

  await Hive.openBox<SingleScore>('single_scores');
  await Hive.openBox<PlayerStats>('player_stats');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ModeSelectionPage(),
    );
  }
}
