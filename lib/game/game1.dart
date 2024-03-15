import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(FPSAimTrainingGame());
}

class FPSAimTrainingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FPS Aim Training',
      home: FPSAimTrainingScreen(),
    );
  }
}

class FPSAimTrainingScreen extends StatefulWidget {
  @override
  _FPSAimTrainingScreenState createState() => _FPSAimTrainingScreenState();
}

class _FPSAimTrainingScreenState extends State<FPSAimTrainingScreen> {
  final int targetCount = 20;
  final double targetSize = 50.0;
  final double targetSpeed = 2.0;
  int score = 0;
  bool gameOver = false;

  List<double> targetPositions = [];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    score = 0;
    gameOver = false;
    targetPositions.clear();
    Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (!gameOver) {
        updateTargets();
      } else {
        timer.cancel();
      }
    });
  }

  void updateTargets() {
    setState(() {
      for (int i = 0; i < targetCount; i++) {
        if (targetPositions.isEmpty || targetPositions.length <= i) {
          targetPositions.add(Random().nextDouble() * (MediaQuery.of(context).size.height - targetSize));
        } else {
          targetPositions[i] += targetSpeed;
          if (targetPositions[i] > MediaQuery.of(context).size.height) {
            targetPositions[i] = Random().nextDouble() * (MediaQuery.of(context).size.height - targetSize);
          }
        }
      }
    });
  }

  void onTapTarget(int index) {
    setState(() {
      score += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FPS Aim Training'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (!gameOver) {
                setState(() {
                  gameOver = true;
                });
              }
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          ...List.generate(
            targetCount,
            (index) {
              return Positioned(
                left: MediaQuery.of(context).size.width / 2 - targetSize / 2,
                top: targetPositions.isNotEmpty ? targetPositions[index] : 0,
                child: GestureDetector(
                  onTap: () {
                    if (!gameOver) {
                      onTapTarget(index);
                    }
                  },
                  child: Container(
                    width: targetSize,
                    height: targetSize,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(targetSize / 2),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Text(
              'Score: $score',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          if (gameOver)
            Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  'Game Over',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
