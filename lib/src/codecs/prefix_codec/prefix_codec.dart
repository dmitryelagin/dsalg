import 'dart:convert';

import '../../bits/bit_array.dart';
import '../../utils/iterable_utils.dart';
import 'prefix_unit_node.dart';

typedef PrefixDictionary = Map<int, Iterable<bool>>;
typedef PrefixDictionaryEntry = MapEntry<int, Iterable<bool>>;

class PrefixCodec extends Codec<String, BitArray> {
  const PrefixCodec(this.encoder, this.decoder);

  PrefixCodec.fromDictionary(PrefixDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        encoder = PrefixEncoder(dictionary),
        decoder = PrefixDecoder(dictionary);

  factory PrefixCodec.fromUncheckedDictionary(PrefixDictionary dictionary) {
    assert(isValidDictionary(dictionary));
    return PrefixCodec.fromDictionary(dictionary);
  }

  @override
  final PrefixEncoder encoder;

  @override
  final PrefixDecoder decoder;

  static bool isValidDictionary(PrefixDictionary dictionary) {
    final paths = dictionary.values.toList()
      ..sort((a, b) => a.length.compareTo(b.length));
    for (var i = 0; i < paths.length - 1; i += 1) {
      final first = paths[i], rest = paths.skip(i + 1);
      for (final path in rest) {
        if (path.startsWith(first)) return false;
      }
    }
    return true;
  }
}

class PrefixEncoder extends Converter<String, BitArray> {
  PrefixEncoder(this._dictionary) : assert(_dictionary.isNotEmpty);

  final PrefixDictionary _dictionary;

  @override
  BitArray convert(String input) {
    assert(input.isNotEmpty);
    return BitArray.from(
      input.codeUnits.expand(
        (unit) => _dictionary[unit] ?? getMissedDictionaryValue(unit),
      ),
    );
  }

  Iterable<bool> getMissedDictionaryValue(int unit) {
    throw StateError(
      'Unit $unit (${String.fromCharCode(unit)}) is missed '
      'in encoder dictionary',
    );
  }
}

class PrefixDecoder extends Converter<BitArray, String> {
  PrefixDecoder(PrefixDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        _root = PrefixUnitNode.fromDictionary(dictionary);

  final PrefixUnitNode<void> _root;

  @override
  String convert(BitArray input) {
    assert(input.isNotEmpty);
    final buffer = StringBuffer();
    var node = _root;
    for (var i = input.length - 1; i >= 0; i -= 1) {
      node = input[i] ? node.right! : node.left!;
      if (node.hasNoChildren) {
        buffer.writeCharCode(node.key);
        node = _root;
      }
    }
    return buffer.toString();
  }
}
