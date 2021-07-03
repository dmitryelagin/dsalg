import 'package:dsalg/src/commons/binary_node.dart';

class BinaryNodeMock<T> extends BinaryNode<T, BinaryNodeMock<T>> {
  BinaryNodeMock(T value) : super(value);
}
