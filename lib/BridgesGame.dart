import 'dart:async';
import 'package:flutter/material.dart';

class BridgesGrid extends StatefulWidget {
  @override
  _BridgesGridState createState() => _BridgesGridState();
}

class _BridgesGridState extends State<BridgesGrid> {
  List<List<int>> bridgesGrid = [
    [4, 0, 3, 0, 2],
    [0, 3, 0, 1, 0],
    [4, 0, 0, 0, 0],
    [0, 4, 0, 0, 3],
    [4, 0, 0, 2, 0],
  ];

  List<List<bool>> isConnected = List.generate(5, (index) => List.generate(5, (index) => false));

  int tappedIsland = -1;
  Timer? timer;
  int secondsElapsed = 0;

void connectIslands(int island1, int island2) {
  setState(() {
    int row1 = island1 ~/ bridgesGrid.length;
    int col1 = island1 % bridgesGrid.length;
    int row2 = island2 ~/ bridgesGrid.length;
    int col2 = island2 % bridgesGrid.length;

    // Mark the connection between the islands in the isConnected list
    if (row1 == row2) {
      isConnected[row1][col1 + 1] = true; // Connect to the right
      isConnected[row2][col2 - 1] = true; // Connect to the left
    } else if (col1 == col2) {
      isConnected[row1 + 1][col1] = true; // Connect below
      isConnected[row2 - 1][col2] = true; // Connect above
    }
  });
  print('Islands $island1 and $island2 connected');
}

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void restartGame() {
    setState(() {
      isConnected = List.generate(5, (index) => List.generate(5, (index) => false));
      secondsElapsed = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bridges Puzzle Game'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')}', // timer
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 300, // Adjust the width of the grid
                height: 300, // Adjust the height of the grid
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: bridgesGrid.length,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: bridgesGrid.length * bridgesGrid.length,
                  itemBuilder: (context, index) {
                    int row = index ~/ bridgesGrid.length;
                    int col = index % bridgesGrid.length;
                    int island = bridgesGrid[row][col];

                    return GestureDetector(
                      onTap: () {
                        if (island != 0) {
                          if (tappedIsland == -1) {
                            tappedIsland = index;
                            print('Island $island tapped');
                          } else {
                            connectIslands(tappedIsland, index);
                            tappedIsland = -1;
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: Size.infinite,
                            painter: BridgesPainter(
                              isConnected: isConnected,
                              cellSize: MediaQuery.of(context).size.width / bridgesGrid.length, // Assuming the grid is a square
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: island == 0 ? Colors.transparent : Colors.blue.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(50), // Make the container a circle
                            ),
                            child: island == 0
                                ? SizedBox() // Hide the container if it's an empty space
                                : Center(
                                    child: Text(
                                      island.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              restartGame();
            },
            child: Text('Restart'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class BridgesPainter extends CustomPainter {
  final List<List<bool>> isConnected;
  final double cellSize;

  BridgesPainter({
    required this.isConnected,
    required this.cellSize,
  });

  @override
void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 2;

  // Loop through the isConnected list to draw bridges
  for (int row = 0; row < isConnected.length; row++) {
    for (int col = 0; col < isConnected[row].length; col++) {
      if (isConnected[row][col]) {
        double startX = col * cellSize + cellSize / 2;
        double startY = row * cellSize + cellSize / 2;

        // Check if there's a connection to the right
        if (col < isConnected[row].length - 1 && isConnected[row][col + 1]) {
          double endX = (col + 1) * cellSize + cellSize / 2;
          double endY = startY;
          canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
        }

        // Check if there's a connection below
        if (row < isConnected.length - 1 && isConnected[row + 1][col]) {
          double endX = startX;
          double endY = (row + 1) * cellSize + cellSize / 2;
          canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
        }
      }
    }
  }
}


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
