import "package:flutter/material.dart";
import "game.dart";
import "colors.dart";

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameBoardWidget(),
    );
  }
}

class GameBoardWidget extends StatefulWidget {
  @override
  _GameBoardWidgetState createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  Board board;
  int row;
  int column;
  bool isGameOver;
  bool isDragging;
  MediaQueryData queryData;
  final double tilePadding = 5.0;

  @override
  void initState() {
    super.initState();
    row = 4;
    column = 4;
    board = Board(row: row, column: column);
    newGame();
  }

  void newGame() {
    board.initBoard();
    isGameOver = false;
    setState(() {});
  }

  void gameOver() {
    setState(() {
      isGameOver = board.gameOver();
    });
  }

  void moveLeft() {
    setState(() {
      board.moveLeft();
      gameOver();
    });
  }

  void moveRight() {
    setState(() {
      board.moveRight();
      gameOver();
    });
  }

  void moveUp() {
    setState(() {
      board.moveUp();
      gameOver();
    });
  }

  void moveDown() {
    setState(() {
      board.moveDown();
      gameOver();
    });
  }

  Size boardSize() {
    Size size = queryData.size;
    return Size(size.width, size.width);
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    List<TileWidget> allTileWidgets = List<TileWidget>();
    // Add all TileWidgets
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        allTileWidgets.add(TileWidget(tile: board.getTile(r, c), state: this));
      }
    }
    List<Widget> allWidgets = List<Widget>();
    allWidgets.add(GameBoardGridWidget(this));
    allWidgets.addAll(allTileWidgets);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                color: new Color(0xffb7a897),
                width: 120,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Score:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(board.score.toString()),
                  ],
                ),
              ),
              FlatButton(
                padding: EdgeInsets.all(1.0),
                color: new Color(0xffb7a897),
                child: Container(
                  width: 120,
                  height: 60,
                  child: Center(
                    child: Text(
                      "New Game",
                    ),
                  ),
                ),
                onPressed: () {
                  newGame();
                },
              )
            ],
          ),
        ),
        Container(
          height: 30.0,
          child: Opacity(
            opacity: isGameOver ? 1.0 : 0,
            child: Text("Game Over!"),
          ),
        ),
        Container(
          width: queryData.size.width,
          height: queryData.size.width,
          child: GestureDetector(
            onVerticalDragUpdate: (detail) {
              if (detail.delta.distance == 0 || isDragging) {
                return;
              }
              isDragging = true;
              if (detail.delta.direction > 0) {
                moveDown();
              } else {
                moveUp();
              }
            },
            onVerticalDragEnd: (detail) {
              isDragging = false;
            },
            onVerticalDragCancel: () {
              isDragging = false;
            },
            onHorizontalDragUpdate: (detail) {
              if (detail.delta.distance == 0 || isDragging) {
                return;
              }
              isDragging = true;
              if (detail.delta.direction > 0) {
                moveLeft();
              } else {
                moveRight();
              }
            },
            onHorizontalDragDown: (detail) {
              isDragging = false;
            },
            onHorizontalDragCancel: () {
              isDragging = false;
            },
            child: Stack(
              children: allWidgets,
            ),
          ),
        ),
      ],
    );
  }
}

class GameBoardGridWidget extends StatelessWidget {
  final _GameBoardWidgetState state;
  GameBoardGridWidget(this.state);

  @override
  Widget build(BuildContext context) {
    Size size = state.boardSize();
    double tileWidth =
        (size.width - (state.column + 1) * state.tilePadding) / (state.column);

    List<TileBox> backgroundBox = List<TileBox>();
    for (int r = 0; r < state.row; r++) {
      for (int c = 0; c < state.column; c++) {
        TileBox tileBox = TileBox(
          top: c * tileWidth + state.tilePadding * (c + 1),
          left: r * tileWidth + state.tilePadding * (r + 1),
          size: tileWidth,
          color: Colors.grey[300],
        );
        backgroundBox.add(tileBox);
      }
    }
    return Positioned(
      top: 0.0,
      left: 0.0,
      child: Container(
        width: state.boardSize().width,
        height: state.boardSize().height,
        child: Stack(
          children: backgroundBox,
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class TileWidget extends StatefulWidget {
  final Tile tile;
  final _GameBoardWidgetState state;
  TileWidget({this.tile, this.state});
  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> {
  Tile tile;
  _GameBoardWidgetState state;

  @override
  void initState() {
    tile = widget.tile;
    state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tile.isEmpty()) {
      return Container();
    }
    Size size = state.boardSize();
    double tileWidth =
        (size.width - (state.column + 1) * state.tilePadding) / (state.column);
    return TileBox(
      left: tile.column * tileWidth + state.tilePadding * (tile.column + 1),
      top: tile.row * tileWidth + state.tilePadding * (tile.row + 1),
      size: tileWidth,
      text: Text(tile.value.toString()),
      color: tileColors.containsKey(tile.value)
          ? tileColors[tile.value]
          : tileColors[tileColors.keys.last],
    );
  }
}

class TileBox extends StatelessWidget {
  final double top;
  final double left;
  final double size;
  final Color color;
  final Text text;
  TileBox({this.top, this.left, this.size, this.color, this.text});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
          child: text,
        ),
      ),
    );
  }
}
