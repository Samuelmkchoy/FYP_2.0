import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:matcher/matcher.dart';

class Tile extends StatelessWidget {
  bool lightOn;
  Tile({super.key, required this.lightOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      color: lightOn ? Colors.white : Colors.grey[900],
    );
  }
}