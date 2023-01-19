import 'dart:collection';
import 'dart:typed_data';

import 'bit_mask.dart';

class BitArray extends ListBase<bool> {
  BitArray([this._minLength = 0]) : _length = _minLength {
    reset();
  }

  factory BitArray.from(Iterable<bool> values, [int minLength = 0]) {
    final array = BitArray(minLength);
    var index = values.length;
    for (final value in values) {
      array[index -= 1] = value;
    }
    return array;
  }

  factory BitArray.fromDataString(String data, [int minLength = 0]) {
    final units = [
      ...data.codeUnits.reversed,
      if (data.codeUnits.length.isOdd) 0,
    ];
    final array = BitArray(minLength)
      .._chunks = Uint32List.sublistView(Uint16List.fromList(units));
    return array.._length = data.codeUnits.length * _charSize;
  }

  static const _charSize = Uint16List.bytesPerElement * 8;

  static const _chunkSize = Uint32List.bytesPerElement * 8;
  static const _chunkIndexMask = _chunkSize - 1;

  static final _chunkIndexSize = _chunkIndexMask.setBitsAmount;

  static final _setMasks = List.generate(_chunkSize, (i) => 1 << i);
  static final _unsetMasks = List.generate(_chunkSize, (i) => ~(1 << i));

  final int _minLength;

  late Uint32List _chunks;

  int _length;

  @override
  int get length => _length;

  @override
  set length(int value) {
    _tryGrowFor(value - 1);
  }

  Iterable<bool> get bits sync* {
    for (var i = 0; i < length; i += 1) {
      yield this[i];
    }
  }

  Iterable<bool> get bitsReversed sync* {
    for (var i = length - 1; i >= 0; i -= 1) {
      yield this[i];
    }
  }

  static int _getChunkIndex(int i) => i >> _chunkIndexSize;
  static int _getMaskIndex(int i) => i & _chunkIndexMask;

  @override
  bool operator [](int i) =>
      length > i &&
      _chunks[_getChunkIndex(i)] & _setMasks[_getMaskIndex(i)] != 0;

  @override
  void operator []=(int i, bool value) {
    (value ? setBit : unsetBit)(i);
  }

  @override
  void add(bool element) {
    this[length] = element;
  }

  bool isSetBit(int i) => this[i];
  bool isUnsetBit(int i) => !this[i];

  void setBit(int i) {
    _tryGrowFor(i);
    _chunks[_getChunkIndex(i)] |= _setMasks[_getMaskIndex(i)];
  }

  void unsetBit(int i) {
    _tryGrowFor(i);
    _chunks[_getChunkIndex(i)] &= _unsetMasks[_getMaskIndex(i)];
  }

  void invertBit(int i) {
    (this[i] ? unsetBit : setBit)(i);
  }

  void setBits(Iterable<int> indexes) {
    indexes.forEach(setBit);
  }

  void unsetBits(Iterable<int> indexes) {
    indexes.forEach(unsetBit);
  }

  void invertBits(Iterable<int> indexes) {
    indexes.forEach(invertBit);
  }

  void reset() {
    _chunks = Uint32List((_minLength / _chunkSize).ceil());
    _length = _minLength;
  }

  String toDataString() {
    final codes = Uint16List.sublistView(_chunks).reversed;
    return String.fromCharCodes(
      length <= (codes.length - 1) * _charSize ? codes.skip(1) : codes,
    );
  }

  void _tryGrowFor(int i) {
    if (length > i) return;
    _length = i + 1;
    if (_chunks.length * _chunkSize > i) return;
    _chunks = Uint32List(_getChunkIndex(i) + 1)
      ..setRange(0, _chunks.length, _chunks);
  }
}
