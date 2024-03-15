// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fyp/game/dot.dart';
import 'package:fyp/game/game2.dart';

import 'game/game1.dart';

void main() {
  runApp(GameMenu());
}

class GameMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Menu'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
            },
          ),
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: () {
              // Navigate to leaderboard page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                children: <Widget>[
                  GameButton(
                    title: 'Aim',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FPSAimTrainingScreen()),
                      );
                    },
                  ),
                  GameButton(
                    title: 'Snake',
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SnakeGame()),
                      );
                    },
                  ),
                  GameButton(
                    title: 'Hashi',
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Hashi()),
                      );
                    },
                  ),
                  GameButton(
                    title: 'Game 4',
                    onPressed: () {
                      // Navigate to game 4
                    },
                  ),
                  GameButton(
                    title: 'Game 5',
                    onPressed: () {
                      // Navigate to game 5
                    },
                  ),
                  GameButton(
                    title: 'Game 6',
                    onPressed: () {
                      // Navigate to game 6
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const GameButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20.0),
        primary: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
