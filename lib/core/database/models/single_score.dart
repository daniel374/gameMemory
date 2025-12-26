import 'package:hive/hive.dart';

part 'single_score.g.dart';

@HiveType(typeId: 2)
class SingleScore extends HiveObject {
  @HiveField(0)
  final String mode; // Ej: "Animales"

  @HiveField(1)
  final int attempts;

  @HiveField(2)
  final DateTime date;

  SingleScore({required this.mode, required this.attempts, required this.date});
}
