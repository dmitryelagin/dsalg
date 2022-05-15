import 'dart:convert';

import '../../bits/bit_array.dart';
import '../../trees/trie/trie.dart';
import '../../utils/iterable_utils.dart';
import '../../utils/map_utils.dart';

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
    for (var i = 1; i < paths.length; i += 1) {
      final first = paths[i - 1], rest = paths.skip(i);
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
        _prefixTree = Trie(Trie.getStandardIterator, dictionary.opposite);

  final Trie<Iterable<bool>, int> _prefixTree;

  @override
  String convert(BitArray input) {
    assert(input.isNotEmpty);
    final buffer = StringBuffer();
    _prefixTree
        .getCyclically(input.bitsReversed.iterator)
        .forEach(buffer.writeCharCode);
    return buffer.toString();
  }
}
