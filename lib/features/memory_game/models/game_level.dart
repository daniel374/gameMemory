enum GameLevel { easy, medium, hard }

extension GameLevelConfig on GameLevel {
  int get pairCount {
    switch (this) {
      case GameLevel.easy:
        return 4;
      case GameLevel.medium:
        return 6;
      case GameLevel.hard:
        return 8;
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
    }
  }
}
