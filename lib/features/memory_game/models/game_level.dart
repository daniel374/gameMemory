enum GameLevel { easy, medium, hard, legendary }

class GridSize {
  final int rows;
  final int columns;

  GridSize({required this.rows, required this.columns});

  int get totalCards => rows * columns;
}

extension GameLevelConfig on GameLevel {
  int get pairCount {
    switch (this) {
      case GameLevel.easy:
        return 6; // 12 cartas
      case GameLevel.medium:
        return 9; // 18 cartas
      case GameLevel.hard:
        return 12; // 24 cartas
      case GameLevel.legendary:
        return 18; // 36 cartas
    }
  }

  // Define grid size as rows and columns
  GridSize get gridSize {
    switch (this) {
      case GameLevel.easy:
        return GridSize(rows: 3, columns: 4);
      case GameLevel.medium:
        return GridSize(rows: 3, columns: 6);
      case GameLevel.hard:
        return GridSize(rows: 3, columns: 8);
      case GameLevel.legendary:
        return GridSize(rows: 3, columns: 12);
    }
  }

  String get title {
    switch (this) {
      case GameLevel.easy:
        return 'Fácil';
      case GameLevel.medium:
        return 'Medio';
      case GameLevel.hard:
        return 'Difícil';
      case GameLevel.legendary:
        return 'Legendario';
    }
  }
}
