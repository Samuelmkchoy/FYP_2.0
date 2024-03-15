// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last

import 'dart:math';
import 'bridge_painter.dart';
import 'package:flutter/material.dart';
import 'bridge.dart';
import 'island.dart';

class HashiGame extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HashiGameState createState() => _HashiGameState();
}

class _HashiGameState extends State<HashiGame> {

  List<BridgePainter> _bridgesPainter = [];

  double calculateIslandTop(int index) {
    return 100 + (index ~/ 3) * 150;
  }

  double calculateIslandLeft(int index) {
    return (index % 3) * 100 + (index % 3) * 25;
  }

  void updateIslandPositions() {
    for (int i = 0; i < islands.length; i++) {
      setState(() {
        islands[i].top = calculateIslandTop(i);
        islands[i].left = calculateIslandLeft(i);
      });
    }
  }

List<Offset> calculateBridgePoints(Island startIsland, Island endIsland) {
  double dx = endIsland.left - startIsland.left;
  double dy = endIsland.top - startIsland.top;
  double distance = sqrt(dx * dx + dy * dy);
  int segments = distance ~/ 20;
  double segmentLength = distance / segments;

  List<Offset> points = [
    Offset(startIsland.left, startIsland.top)
  ];

  for (int i = 1; i < segments; i++) {
    double x = startIsland.left + i * segmentLength * dx / distance;
    double y = startIsland.top + i * segmentLength * dy / distance;
    points.add(Offset(x, y));
  }

  // Adjust the end point to snap to the center of the end island
  Offset endPoint = Offset(endIsland.left, endIsland.top);
  points.add(endPoint);

  return points;
}
  
  // Initialize the islands list
  List<Island> islands = List.generate(9, (index) {
    return Island(id: index);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasi Game'),
      ),
      body: Stack(
        children: [
          Center(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                Island island = islands[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (!island.isBridgeStart) {
                      island.isBridgeStart = true;
                    } else if (!island.isBridgeEnd) {
                      island.isBridgeEnd = true;

                      if (isValidBridge(island, islands)) {
                        Bridge newBridge = Bridge(
                          startIsland: island,
                          endIsland: getBridgeEndIsland(island, islands),
                        );

                        setState(() {
                          bridges.add(newBridge);
                        });

                        updateIslandPositions();
                      } else {
                        island.isBridgeStart = false;
                        island.isBridgeEnd = false;
                      }
                    } else {
                      island.isBridgeStart = false;
                      island.isBridgeEnd = false;
                    }
                    _bridgesPainter.add(BridgePainter(bridgePoints: calculateBridgePoints(island, getBridgeEndIsland(island, islands))));
                  });
                  updateIslandPositions();
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isValidMove(island)
                        ? island.bridgesCount > 0 ? Colors.green : Colors.blue
                        : Colors.red,
                  ),
                  margin: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      island.bridgesCount.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
            itemCount: 9, // 3x3 grid
          ),
        ),
        CustomPaint(
            painter: BridgePainter(
              bridgePoints: calculateBridgePoints(
                islands[0],
                islands[4],
              ),
            ),
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
          ),
        ],
      ),
    );
  }
}

class BridgePainterCollection extends CustomPainter {
  List<BridgePainter> bridges;

  BridgePainterCollection({required this.bridges});

  @override
  void paint(Canvas canvas, Size size) {
    for (BridgePainter bridgePainter in bridges) {
      bridgePainter.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

bool isValidMove(Island island) {
  return island.isBridgeStart && island.isBridgeEnd ||
      island.bridgesCount == 0 &&
          (island.isBridgeStart || island.isBridgeEnd);
}

bool isValidBridge(Island island, List<Island> islands) {
  int adjacentBridgesCount = 0;

  // Find the adjacent islands with bridges
  for (int i = island.id - 1; i <= island.id + 1; i++) {
    if (i >= 0 && i < islands.length && islands[i].bridgesCount > 0) {
      adjacentBridgesCount++;
    }
  }

  // Check if the bridge is valid
  return adjacentBridgesCount == 1 &&
      !island.isBridgeStart &&
      !island.isBridgeEnd;
}

Island getBridgeEndIsland(Island island, List<Island> islands) {
  int targetId = island.id;
  int bridgeLength = island.bridgesCount;

  if (island.id % 3 == 0) {
    // The island is at the left edge
    targetId += bridgeLength;
  } else if ((island.id - 1) % 3 == 0) {
    // The island is at the right edge
    targetId -= bridgeLength;
  } else if (island.id < bridgeLength) {
    // The island is at the top edge
    targetId += 3 * bridgeLength - 1;
  } else {
    // The island is at the bottom edge
    targetId -= 3 * bridgeLength - 1;
  }

  return islands[targetId];
}

void drawGrid(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  // Draw vertical lines
  for (int i = 0; i < 3; i++) {
    double x = 100 * i + 50;
    canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
  }

  // Draw horizontal lines
  for (int i = 0; i < 4; i++) {
    double y = 100 * i + 50;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
}

