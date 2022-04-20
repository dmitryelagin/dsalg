import 'dart:convert';

import '../bits/bit_array.dart';
import '../helpers/bisect.dart';
import '../helpers/code_unit_frequencies.dart';
import 'base_unit_codec.dart';

class ShannonFanoCodec extends Codec<String, BitArray> {
  const ShannonFanoCodec(this.encoder, this.decoder);

  ShannonFanoCodec.fromDictionary(UnitDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        encoder = ShannonFanoEncoder(dictionary),
        decoder = ShannonFanoDecoder.fromDictionary(dictionary);

  factory ShannonFanoCodec.from(String message) =>
      ShannonFanoCodec.fromDictionary(createDictionary(message));

  static UnitDictionary createDictionary(String message) =>
      _ShannonFanoNode.fromString(message).toDictionary();

  @override
  final ShannonFanoEncoder encoder;

  @override
  final ShannonFanoDecoder decoder;
}

class ShannonFanoEncoder extends BaseUnitEncoder {
  ShannonFanoEncoder(super.dictionary);
}

class ShannonFanoDecoder extends BaseUnitDecoder<_ShannonFanoNode> {
  ShannonFanoDecoder.fromDictionary(UnitDictionary dictionary)
      : assert(dictionary.isNotEmpty),
        super(_ShannonFanoNode.fromDictionary(dictionary));
}

class _ShannonFanoNode extends BaseUnitNode<Iterable<bool>, _ShannonFanoNode> {
  _ShannonFanoNode(super.key, super.value);

  _ShannonFanoNode.utility([
    Iterable<bool> value = const [],
    List<int> units = const [],
    int Function(int) getMass = _getDefaultMass,
  ]) : super(-1, value) {
    if (units.isEmpty) return;
    final parts = units.bisectByMass(getMass);
    final leftPath = value.followedBy(const [false]);
    final rightPath = value.followedBy(const [true]);
    left = parts.first.length == 1
        ? _ShannonFanoNode(parts.first.first, leftPath)
        : _ShannonFanoNode.utility(leftPath, parts.first.toList(), getMass);
    right = parts.second.length == 1
        ? _ShannonFanoNode(parts.second.first, rightPath)
        : _ShannonFanoNode.utility(rightPath, parts.second.toList(), getMass);
  }

  factory _ShannonFanoNode.fromString(String message) {
    assert(message.isNotEmpty);
    final unitCounters = message.codeUnitFrequencies;
    if (unitCounters.length == 1) {
      return _ShannonFanoNode(unitCounters.keys.first, const [false]);
    } else {
      final units = unitCounters.keys.toList()
        ..sort((a, b) => unitCounters[b]!.compareTo(unitCounters[a]!));
      int getMass(int unit) => unitCounters[unit]!;
      return _ShannonFanoNode.utility(const [], units, getMass);
    }
  }

  factory _ShannonFanoNode.fromDictionary(UnitDictionary dictionary) =>
      BaseUnitNode.fromDictionary(_ShannonFanoNode.utility, dictionary);

  static Iterable<MapEntry<int, Iterable<bool>>> _createDictionaryEntries(
    _ShannonFanoNode node,
  ) sync* {
    if (node.hasNoChildren) {
      yield MapEntry(node.key, node.value);
    } else {
      yield* _createDictionaryEntries(node.left!);
      yield* _createDictionaryEntries(node.right!);
    }
  }

  static int _getDefaultMass(int _) => 1;

  UnitDictionary toDictionary() =>
      Map.fromEntries(_createDictionaryEntries(this));
}
