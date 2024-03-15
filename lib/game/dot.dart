import 'package:flutter/material.dart';

class Hashi extends StatefulWidget {
  @override
  _HashiState createState() => _HashiState();
}

class _HashiState extends State<Hashi> {
  final List<List<int>> puzzle = [
    [4, 0, 3, 0, 2],
    [0, 3, 0, 1, 0],
    [4, 0, 0, 0, 0],
    [0, 4, 0, 0, 3],
    [4, 0, 0, 2, 0],
  ];

  List<Offset> bridges = [];
  bool puzzleSolved = false;
  Offset? selectedIsland = null;

  void _onButtonTap(int row, int col) {
    if (!puzzleSolved) {
      setState(() {
        if (selectedIsland == null) {
          // Tap the first island
          selectedIsland = _getBridgePosition(row, col);
          print("$selectedIsland Tapped");
        } else {
          // Tap the second island, connect them
          bridges.addAll(
              [selectedIsland ?? Offset.zero, _getBridgePosition(row, col)]);
          selectedIsland = null;

          // If you want to do something specific when islands are connected, add logic here

          if (_isPuzzleSolved()) {
            _showPuzzleSolvedDialog();
          }
        }
      });
    }
  }

  Offset _getBridgePosition(int row, int col) {
    // Calculate the position based on the row and column
    double x = col * 70.0 + 50.0;
    double y = row * 70.0 + 50.0;

    return Offset(x, y);
  }

  bool _isPuzzleSolved() {
    // Implement logic to check if the puzzle is solved
    // You can compare the current puzzle grid with the solved state
    return false;
  }

  void _showPuzzleSolvedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Puzzle Solved!'),
          content: Text('Congratulations! You solved the puzzle.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    setState(() {
      puzzleSolved = true;
    });
  }

  void _resetPuzzle() {
    setState(() {
      bridges.clear();
      puzzleSolved = false;
      selectedIsland = null;
    });
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Hashiwokakero Puzzle'),
    ),
    body: Center(
      child: Container(
        width: 350.0, // Adjust this value according to your needs
        height: 350.0, // Adjust this value according to your needs
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int row = 0; row < puzzle.length; row++)
              for (int col = 0; col < puzzle[row].length; col++)
                if (puzzle[row][col] > 0)
                  Positioned(
                    left: _getBridgePosition(col, row).dx - 25, // Adjusted position to center island
                    top: _getBridgePosition(col, row).dy - 25, // Adjusted position to center island
                    child: ElevatedButton(
                      onPressed: () => _onButtonTap(col, row),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(puzzle[row][col].toString()),
                        ],
                      ),
                    ),
                  ),
            for (int i = 0; i < bridges.length - 1; i += 2)
              Positioned(
                left: bridges[i].dx - 25, // Adjusted position to center bridge
                top: bridges[i].dy - 25, // Adjusted position to center bridge
                child: CustomPaint(
                  painter: LinePainter(bridges[i], bridges[i + 1]),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}


}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  LinePainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}