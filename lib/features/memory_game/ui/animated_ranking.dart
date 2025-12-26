import 'package:flutter/material.dart';

class AnimatedRankingTile extends StatelessWidget {
  final int position;
  final String title;
  final String subtitle;

  const AnimatedRankingTile({
    super.key,
    required this.position,
    required this.title,
    required this.subtitle,
  });

  Color get medalColor {
    switch (position) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (_, scale, child) => Transform.scale(
        scale: scale,
        child: Opacity(opacity: scale, child: child),
      ),
      child: Card(
        color: medalColor.withOpacity(0.2),
        child: ListTile(
          leading: Text('🏆 ${position + 1}'),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}
