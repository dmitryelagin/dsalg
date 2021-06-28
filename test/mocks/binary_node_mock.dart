import 'package:dsalg/src/commons/binary_node.dart';

class BinaryNodeMock<T> extends BinaryNode<T, BinaryNodeMock<T>> {
  BinaryNodeMock(T value, [BinaryNodeMock<T>? left, BinaryNodeMock<T>? right])
      : super(value, left, right);
}
