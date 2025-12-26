import 'package:hive/hive.dart';

part 'single_score.g.dart';

@HiveType(typeId: 2)
class SingleScore extends HiveObject {
  @HiveField(0)
  String mode;

  @HiveField(1)
  int attempts;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String category; // Animals, Letters, Numbers

  @HiveField(4)
  String level; // Fácil, Medio, Difícil

  SingleScore({
    required this.mode,
    required this.attempts,
    required this.date,
    required this.category,
    required this.level,
  });
}
