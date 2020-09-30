# Part 1 / Workshop 5 - Game logic design

## Setting Up

### Learning Outcomes

* Using dart to create the idea of the 2048 game logic.
* Creating a board with tiles on it, and implmenting the features that will happen if you merge.
* Transitioning that logic to a state where it can be used in conjunction with Flutter to make an app.

## Pre-requisites
If you have created a Flutter app before, you can ignore this section. It is also useful to visit [2048](https://play2048.co/) to play around to get more familiar with the game.

It is highly recommended you visit our first workshop link [to setting up a Flutter environment](https://dsc.community.dev/events/details/developer-student-clubs-university-of-melbourne-presents-flutter-workshop1-basics-of-flutter-and-making-your-very-first-app/#/)

Below are a few rough steps on what you need before starting this project.
### Dart

https://dart.dev/

### Visual Studio Code / Android Studio / Flutlab

https://code.visualstudio.com/download
https://developer.android.com/studio
https://flutlab.io/

### Making a Directory

For simplity, we will be using Visual Studio Code as our code editor for describing these steps. If you are using flutlab.io, you don't need to worry about creating the project structure, since it will be already done for you.

* First, in Visual Studio Code, choose the directory you want to create your project in through  `Ctrl+K Ctrl+O`. 
* Then `Ctrl shift p` and select `Flutter: New Project` and then choosing a Flutter project name, such as `two_zero_four_eight`. Alternatively, you can open up your terminal through selecting `Terminal` on the top window bar and clicking `New Terminal`. Then in the terminal, type `flutter create two_zero_four_eight`.

## Stage 1: Initialising a board and creating tiles.

### Step 1: Initialise the game with a board and tile
```Dart
// Your code should look like:
class Board {
  final int row;
  final int column;

  Board({this.row, this.column});
}

class Tile {
  int row;
  int column;
  int value;
  // You will see the use of this variable in step 4
  bool canMerge;

  Tile({this.row, this.column, this.value, this.canMerge});
}
```

### Step 2: Create tiles on the board
Initialise the board with tiles. If we imagine we have a 4x4 board, we will have 16 Tiles. 
We should initialise the board like a 2d array, rather than a single list. This is because it will be easier to access
the board by specifying the row and column in a 2d array. 
Example - If our gameBoard was like this:
```
x x x 
x x x
x x A
```

We can access element A by gameBoard[2][2]

Lets also create a helper function to get a specific Tile from the gameBoard. Although we can access it like
gameBoard[r][c], the code will look much cleaner with a function that does that for us.

```Dart
// Your code should look like:
class Board {
  final int row;
  final int column;

  Board({this.row, this.column});

  List<List<Tile>> gameBoard;

  void initBoard() {
    gameBoard = List<List<Tile>>();
    // Similar to initialising a 2D array
    for (int r = 0; r < row; r++) {
      gameBoard.add(List<Tile>());
      for (int c = 0; c < column; c++) {
        gameBoard[r].add(Tile(
          row: r,
          column: c,
          value: 0,
          canMerge: false,
        ));
      }
    }
  }

  Tile getTile(int row, int column) {
    return gameBoard[row][column];
  }
}

class Tile {
  int row;
  int column;
  int value;
  bool canMerge;

  Tile({this.row, this.column, this.value, this.canMerge});
}
```

### Step 3: Generating random tiles on the board
In 2048, there will be Tiles that are empty, and tiles with values. Whenever you make a swipe,
one of the empty tiles by random will take a value either 2 (90% chance) or 4 (10% chance).

We need to first indiciate a way to show if a tile is empty or not (ie. Has a number on top). Thus we create an isEmpty() function in Tiles.
A tile will be empty if its value is 0.

Recall that each state in the 2048 board, there will be a new non-empty tile showing a number. We want to randomly
make a Tile not empty, and that randomly created Tile will either have a value 2 (90% chance) or 4 (10% chance). The chances 
can be easily changed if we want different chances.

We want the function to create a certain number of Tiles with values that were initially empty tiles.

```Dart
// Add this to your code
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

    // Randomly choose an empty tile to be a newly created Tile "count" number of times.
    for (int i = 0; i < count; i ++) {
      Random random = Random();
      int randIndex = random.nextInt(allEmptyTiles.length);
      // Note here we have a 1/10 chance in getting 0, so there is 10% chance of getting 4 on the Tile.
      allEmptyTiles[randIndex].value = random.nextInt(10) == 0 ? 4 : 2;
      allEmptyTiles.removeAt(randIndex);
    }
  }

```

### Step 4: Merging logic (Challenging!)
Now we are moving onto the merging functions. This is probably the hardest part of this workshop so 
it is useful to visualise these with examples so you can see and understand the logic.

We consider a merge if there are two tiles, and one of the tiles has their values changed.
Starting off with an example, swipe left from here:
We want a loop that merges tiles in the dependency order left to right. i.e. merge b with a, then c with b then with a, then d with c then with b then with a.
```
a b c d
2 2 4 2
0 0 0 0
0 0 0 0 
0 0 0 0
```
Let a be the 1st row 1st column, let b be 1st row 2nd column, etc.
We merge a and b together, so now a should become 4 and b should reset to 0. a will have isMerged = true.
```
a b c d
4 0 4 2
0 0 0 0
0 0 0 0 
0 0 0 0
```
Now consider the 2nd and 3rd columns.
Merging b and c together, b should take the value of 4, because b was empty/0. Since we shifted c to b
, c should be 0 in this iteration. b will have isMerged = true
```
a b c d
4 4 0 2
0 0 0 0
0 0 0 0
0 0 0 0
```
Now we go back to merging b with a. However, for each swipe we only want a tile to be merged at maximum once IF they changed value. 
This is why we have the variable isMerged in our tiles. (In this case, a and b will have isMerged = true, so we know not to merge them)

Lastly considering c and d, c wll take the value of d, and d will become 0. Since c changed its value, 
its isMerged is also true, but for d, its not. Since b has isMerged = true, c will not merge onto b.
So in the end, the swipe was:
```
a b c d           a b c d
2 2 4 2           4 4 2 0
0 0 0 0     =>    0 0 0 0
0 0 0 0           0 0 0 0
0 0 0 0           0 0 0 0
```
It is important to know the dependency order depending on which swipe we did. For example, for swiping up it would be:
```
a 2 2 4 2
b 0 0 0 0
c 0 0 0 0
d 0 0 0 0
```
Thus we can create a function canMerge() to test if 2 Tiles (a and b) can merge together.
Remember that we want to merge b into a and a successful merge is if one of the Tile value changes.
If Tile a has already merged, then we can't merge a and b.
If Tile a hasn't merged yet, we can have 2 scenarios:
i) Merging 2 of the same numbers
ii) Merging a number into an empty tile

```Dart
// Add this to your code 
bool canMerge(Tile a, Tile b) {
  return !a.isMerged &&
      ((a.isEmpty() && !b.isEmpty()) || (!b.isEmpty() && a.value == b.value));
}
```

Using this canMerge function, we can implement the function of merging two tiles now.
```Dart
// Add this to your code
void merge(Tile a, Tile b) {
  // Eg. Merging a tile into a tile that was merged before already
  if (!canMerge(a, b)) {
    if (a.isMerged && !b.isEmpty()) {
      b.isMerged = true;
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
    a.isMerged = true;
    b.value = 0;
  }
  // Eg. Merging a 2 onto a 4
  else {
    b.isMerged = true;
  }
}
```

### Step 5: Merging functions
There are different directions we can merge 2 tiles (depends if you swipe left, right, up or down)
We need to create functions that implement the logic when we swipe left, right, up or down.

Instead of just merging 2 tiles side by side, we need to loop it through. This can be seen in this example: Swipe left
```
a b c d
0 0 0 2
0 0 0 0
0 0 0 0
0 0 0 0
```
If we only merged once adjacently d with c, then the board will be wrong because we want to push that value to the very left.
```Dart
// Add this to your code
void mergeLeft(int r, int c) {
  while (c > 0) {
    // gameBoard[r][c-1] is Tile a, gameBoard[r][c] is Tile b
    merge(gameBoard[r][c-1], gameBoard[r][c]);
    c -= 1;
  }
}
```
If we want to mergeRight, we would merge c onto d, then b onto c then onto d, then a onto b then onto c then onto d.

```Dart
// Add this to your code
void mergeRight(int r, int c) {
  while (c < column - 1) {
    merge(gameBoard[r][c + 1], gameBoard[r][c]);
    c += 1;
  }
}
```
EXERCISE: Can you do the same for mergeUp and mergeDown? Think about the dependency order of the direction.
#### Solutions:
```Dart
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
```

### Step 6: Checking the merges
There are times where we can't move swipe in a direction because all the Tiles are already on that direction side.
Example: Swipe left
```
4 2 0 0
2 4 0 0
0 0 0 0
0 0 0 0
```
Here, we can't swipe left because nothing will change. 
Thus we need functions to check if we can swipe in a certain direction.
Similar to step 5, we need to create checks for these in each direction.

We need to loop through every Tile on our gameBoard and shift them left to right.

```Dart
// Add this to your code
bool canMoveLeft() {
  for (int r = 0; r < row; r++) {
    // Careful c shouldn't start at 0
    for (int c = 1; c < column; c++) {
      if (canMerge(gameBoard[r][c], gameBoard[r][c - 1])) {
        return true;
      }
    }
  }
  return false;
}
```

For moving right we need to be careful. Before we iterated the tiles from left to right,
but not we want to iterate through the tiles from right to left.

```Dart
// Add this to your code
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
```
EXERCISE: Can you do the same for canMoveUp, canMoveDown?
Solutions:
```Dart
// Add this to your code
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
```

### Step 7: Move functions
We can now start implementing our move functions. It will check if we can move in a certain direction,
then iterate through each tile and merge in that direction.

```Dart
// Add this to your code
void moveLeft() {
  if (!canMoveLeft()) {
    return;
  }
  for (int r = 0; r < row; r++) {
    for (int c = 0; c < column; c++) {
      mergeLeft(r, c);
    }
  }
}
```

EXERCISE: Do the same for moveRight, moveUp and moveDown
Solutions:
```Dart
// Add this to your code
void moveRight() {
  if (!canMoveRight()) {
    return;
  }
  for (int r = 0; r < row; r++) {
    for (int c = column - 2; c >= 0; c--) {
      mergeRight(r, c);
    }
  }
}

void moveUp() {
  if (!canMoveUp()) {
    return;
  }
  for (int r = 0; r < row; r++) {
    for (int c = 0; c < column; c++) {
      mergeLeft(r, c);
    }
  }
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
}
```

### Step 8: Resetting merges
After we make a move, we want to generate new tiles from empty tiles. We also want to
reset all the isMerged from all the Tiles because after we make a swipe we're in a new
state and the Tiles can be merged again.
First at the end of each move function, lets call the randomEmptyTile().
Secondly, lets create a function to reset all the tiles back to isMerged = false.  
EXERCISE: Implement the function resetMergeState() and add that function and randomEmptyTile() to all the move functions.  
Solution:
```Dart
// Add this to your code
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
        mergeLeft(r, c);
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
```

### Step 9: Finishing touches for the game logic. 
When we initialise the board, we want there to be already 2 starting random Tiles. Hence we should implement that feature in
initBoard().
We also want a scoring system and to know when the game is finished.
Ideally we should start with a score of 0. Every merge we make, we add that value to our score.
Finally, we want to know when our game is finished. 
```Dart
// Add this to your code
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
    // Start the game off with 2 random non-empty Tiles
    randomEmptyTile(2);
    // Start the game off with a score of 0
    score = 0;
  }

   void merge(Tile a, Tile b) {
    // Eg. Merging a tile into a tile that was merged before already
    if (!canMerge(a, b)) {
      if (a.isMerged && !b.isEmpty()) {
        b.isMerged = true;
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
      a.isMerged = true;
      b.value = 0;
      // Add a score
      score += a.value;
    }
    // Eg. Merging a 2 onto a 4
    else {
      b.isMerged = true;
    }
  }
```
EXERCISE: Implement a function bool gameOver(). HINT: Use previous functions. 
Solution:
```Dart
  bool gameOver() {
    return !canMoveDown() && !canMoveLeft() && !canMoveRight() && !canMoveUp();
  }
```

We are now finally done with the game logic! Now we shall move onto part 2: Flutter UI