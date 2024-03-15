// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:fyp/game/tile.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

enum DIRECTION {
  left,
  right,
  up,
  down,
}

class _SnakeGameState extends State<SnakeGame> {

  //Grid dimensions
  int rowCount = 10;
  int colCount = 10;

  //snake position
  List<int> snakePos =[0, 1, 2, 3];
  var snakeDirection = DIRECTION.right;

  //food position
  int foodPos = 14;

  // start game
  void startGame(){}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //grid
          Expanded(
            child: GridView.builder(
              itemCount: rowCount * colCount,
              gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: colCount),
              itemBuilder: (context, index) {
                // snake tile
                if (snakePos.contains(index)) {
                  return Tile(lightOn: true);
                }
                // black tile
                else{
                  return Tile(lightOn: false);
                }
              },
            ),
          ),
          // restart button
          MaterialButton(
            onPressed: startGame,
            child: Text('Play'), 
            color: Colors.green,
          )

        ],
      ),
    );
  }
}