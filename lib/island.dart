class Island {
  final int id;
  bool isBridgeStart;
  bool isBridgeEnd;
  int bridgesCount;
  double top;
  double left;

  Island({
    required this.id,
    this.isBridgeStart = false,
    this.isBridgeEnd = false,
    this.bridgesCount = 0,
    this.top = 0.0,
    this.left = 0.0,
  });
}