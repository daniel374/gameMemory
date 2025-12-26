import 'package:flutter/material.dart';
import '../../../core/database/game_database.dart';
import '../../../core/database/models/single_score.dart';
import '../../../core/database/models/player_stats.dart';

class RankingsPage extends StatelessWidget {
  const RankingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏆 Rankings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('🥇 Top Single Player'),
          _buildSinglePlayer('Animales'),

          const SizedBox(height: 32),

          _sectionTitle('👨‍👩‍👧‍👦 Multijugador'),
          _buildMultiplayer(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 SINGLE PLAYER
  Widget _buildSinglePlayer(String mode) {
    return FutureBuilder<List<SingleScore>>(
      future: GameDatabase.getTopSingleScores(mode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay registros aún'),
          );
        }

        final scores = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scores.length,
          itemBuilder: (context, i) {
            final medal = ['🥇', '🥈', '🥉'][i];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _medalColor(i),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(medal, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Text(
                    '${scores[i].attempts} intentos',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 🔹 MULTIPLAYER
  Widget _buildMultiplayer() {
    return FutureBuilder<List<PlayerStats>>(
      future: GameDatabase.getTopPlayers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay partidas aún'),
          );
        }

        final players = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: players.length,
          itemBuilder: (context, i) {
            final player = players[i];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade300,
                child: Text('${i + 1}'),
              ),
              title: Text(player.name),
              trailing: Text(
                '🏆 ${player.wins}',
                style: const TextStyle(fontSize: 18),
              ),
            );
          },
        );
      },
    );
  }

  Color _medalColor(int i) {
    switch (i) {
      case 0:
        return Colors.amber.shade300;
      case 1:
        return Colors.grey.shade300;
      case 2:
        return Colors.brown.shade300;
      default:
        return Colors.white;
    }
  }
}
