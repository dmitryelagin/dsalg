enum HexagonalDirection {
  flatToppedTop,
  flatToppedTopRight,
  flatToppedBottomRight,
  flatToppedBottom,
  flatToppedBottomLeft,
  flatToppedTopLeft,
  pointyToppedTopLeft,
  pointyToppedTopRight,
  pointyToppedRight,
  pointyToppedBottomRight,
  pointyToppedBottomLeft,
  pointyToppedLeft;
}

enum FlatToppedHexagonalDirection {
  top(HexagonalDirection.flatToppedTop),
  topRight(HexagonalDirection.flatToppedTopRight),
  bottomRight(HexagonalDirection.flatToppedBottomRight),
  bottom(HexagonalDirection.flatToppedBottom),
  bottomLeft(HexagonalDirection.flatToppedBottomLeft),
  topLeft(HexagonalDirection.flatToppedTopLeft);

  const FlatToppedHexagonalDirection(this.alias);

  final HexagonalDirection alias;
}

enum PointyToppedHexagonalDirection {
  topLeft(HexagonalDirection.pointyToppedTopLeft),
  topRight(HexagonalDirection.pointyToppedTopRight),
  right(HexagonalDirection.pointyToppedRight),
  bottomRight(HexagonalDirection.pointyToppedBottomRight),
  bottomLeft(HexagonalDirection.pointyToppedBottomLeft),
  left(HexagonalDirection.pointyToppedLeft);

  const PointyToppedHexagonalDirection(this.alias);

  final HexagonalDirection alias;
}
