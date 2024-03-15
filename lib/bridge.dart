import 'island.dart';

class Bridge {
  final Island startIsland;
  final Island endIsland;

  Bridge({required this.startIsland, required this.endIsland});
}

// Add bridges to the `HashiGame` state
List<Bridge> bridges = [];