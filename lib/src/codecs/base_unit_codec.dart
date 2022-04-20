import 'dart:convert';

import '../bits/bit_array.dart';
import '../trees/binary_tree/base_binary_node.dart';

typedef UnitDictionary = Map<int, Iterable<bool>>;
typedef UnitDictionaryEntry = MapEntry<int, Iterable<bool>>;

class BaseUnitEncoder extends Converter<String, BitArray> {
  BaseUnitEncoder(this._dictionary) : assert(_dictionary.isNotEmpty);

  final UnitDictionary _dictionary;

  @override
  BitArray convert(String input) {
    assert(input.isNotEmpty);
    return BitArray.from(
      input.codeUnits.expand((unit) {
        return _dictionary[unit] ?? getMissedDictionaryValue(unit);
      }),
    );
  }

  Iterable<bool> getMissedDictionaryValue(int unit) {
    final char = String.fromCharCode(unit);
    throw StateError('Missing unit $unit ($char) in encoder dictionary');
  }
}

class BaseUnitDecoder<T extends BaseUnitNode<Object, T>>
    extends Converter<BitArray, String> {
  BaseUnitDecoder(this._rootUnitNode);

  final T _rootUnitNode;

  @override
  String convert(BitArray input) {
    assert(input.isNotEmpty);
    final buffer = StringBuffer();
    var node = _rootUnitNode;
    for (var i = input.length - 1; i >= 0; i -= 1) {
      node = input[i] ? node.right! : node.left!;
      if (node.hasNoChildren) {
        buffer.writeCharCode(node.key);
        node = _rootUnitNode;
      }
    }
    return buffer.toString();
  }
}

class BaseUnitNode<T, N extends BaseUnitNode<T, N>>
    extends BaseBinaryNode<int, T, N> {
  BaseUnitNode(super.key, super.value);

  static N fromDictionary<N extends BaseUnitNode<Object, N>>(
    N Function() createUnitNode,
    UnitDictionary dictionary,
  ) {
    final root = createUnitNode();
    var node = root;
    for (final unit in dictionary.keys) {
      for (final isRight in dictionary[unit]!) {
        node = isRight
            ? node.right ??= createUnitNode()
            : node.left ??= createUnitNode();
      }
      node.key = unit;
      node = root;
    }
    return root;
  }
}
