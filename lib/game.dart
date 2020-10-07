import 'dart:math' show Random;

class Board {
  final int row;
  final int column;
  int score;

  Board({this.row, this.column});

  List<List<Tile>> gameBoard;

  void initBoard() {
    gameBoard = List<List<Tile>>();
    for (int r = 0; r < row; r++) {
      gameBoard.add(List<Tile>());
      for (int c = 0; c < column; c++) {
        gameBoard[r].add(Tile(
          row: r,
          column: c,
          value: 0,
          isMerged: false,
          isNew: false,
        ));
      }
    }
    randomEmptyTile(2);
    // Start the game off with a score of 0
    score = 0;
  }

  Tile getTile(int row, int column) {
    return gameBoard[row][column];
  }

  void randomEmptyTile(int count) {
    List<Tile> allEmptyTiles = List<Tile>();
    // Loop through all Tiles on the gameboard
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        // If the tile is empty
        if (gameBoard[r][c].isEmpty()) {
          allEmptyTiles.add(gameBoard[r][c]);
        }
      }
    }

    // If there are no empty Tiles available, just return
    if (allEmptyTiles.isEmpty) {
      return;
    }

    // Randomly choose an empty tile to be a newly created Tile "count" value of times
    for (int i = 0; i < count; i++) {
      Random random = Random();
      int randIndex = random.nextInt(allEmptyTiles.length);
      allEmptyTiles[randIndex].value = random.nextInt(10) == 0 ? 4 : 2;
      allEmptyTiles[randIndex].isNew = true;
      allEmptyTiles.removeAt(randIndex);
    }
  }

  bool canMerge(Tile a, Tile b) {
    return !a.isMerged &&
        ((a.isEmpty() && !b.isEmpty()) || (!b.isEmpty() && a.value == b.value));
  }

  void merge(Tile a, Tile b) {
    // Eg. Merging a 2 onto a 4
    if (!canMerge(a, b)) {
      if (!a.isMerged && !b.isEmpty()) {
        a.isMerged = true;
      }
      return;
    }

    // 3 Scenarios now
    // Eg. Merging 2 onto an empty cell
    if (a.isEmpty()) {
      a.value = b.value;
      b.value = 0;
      // Eg. Merging 2 onto 2
    } else if (a.value == b.value) {
      a.value = a.value + b.value;
      b.value = 0;
      score += a.value;
      a.isMerged = true;
    }
    // Every other scenario
    else {
      a.isMerged = true;
    }
  }

  void mergeLeft(int r, int c) {
    while (c > 0) {
      merge(gameBoard[r][c - 1], gameBoard[r][c]);
      c -= 1;
    }
  }

  void mergeRight(int r, int c) {
    while (c < column - 1) {
      merge(gameBoard[r][c + 1], gameBoard[r][c]);
      c += 1;
    }
  }

  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(gameBoard[r - 1][c], gameBoard[r][c]);
      r -= 1;
    }
  }

  void mergeDown(int r, int c) {
    while (r < row - 1) {
      merge(gameBoard[r + 1][c], gameBoard[r][c]);
      r += 1;
    }
  }

  bool canMoveLeft() {
    for (int r = 0; r < row; r++) {
      for (int c = 1; c < column; c++) {
        if (canMerge(gameBoard[r][c - 1], gameBoard[r][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < row; r++) {
      for (int c = column - 2; c >= 0; c--) {
        if (canMerge(gameBoard[r][c + 1], gameBoard[r][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int r = 1; r < row; r++) {
      for (int c = 0; c < column; c++) {
        if (canMerge(gameBoard[r - 1][c], gameBoard[r][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int r = row - 2; r >= 0; r--) {
      for (int c = 0; c < column; c++) {
        if (canMerge(gameBoard[r + 1][c], gameBoard[r][c])) {
          return true;
        }
      }
    }
    return false;
  }

  void moveLeft() {
    if (!canMoveLeft()) {
      return;
    }
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        mergeLeft(r, c);
      }
    }
    randomEmptyTile(1);
    resetMergeState();
  }

  void moveRight() {
    if (!canMoveRight()) {
      return;
    }
    for (int r = 0; r < row; r++) {
      for (int c = column - 2; c >= 0; c--) {
        mergeRight(r, c);
      }
    }
    randomEmptyTile(1);
    resetMergeState();
  }

  void moveUp() {
    if (!canMoveUp()) {
      return;
    }
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        mergeUp(r, c);
      }
    }
    randomEmptyTile(1);
    resetMergeState();
  }

  void moveDown() {
    if (!canMoveDown()) {
      return;
    }
    for (int r = row - 2; r >= 0; r--) {
      for (int c = 0; c < column; c++) {
        mergeDown(r, c);
      }
    }
    randomEmptyTile(1);
    resetMergeState();
  }

  void resetMergeState() {
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        gameBoard[r][c].isMerged = false;
      }
    }
  }

  bool gameOver() {
    return !canMoveDown() && !canMoveLeft() && !canMoveRight() && !canMoveUp();
  }
}

class Tile {
  int row;
  int column;
  int value;
  bool isMerged = false;
  bool isNew = false;

  Tile({this.row, this.column, this.value, this.isMerged, this.isNew});

  // Returns if the Tile is empty
  bool isEmpty() {
    return value == 0;
  }
}
