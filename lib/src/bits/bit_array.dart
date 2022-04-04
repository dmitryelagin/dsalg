import 'dart:typed_data';

import 'bit_mask.dart';

class BitArray {
  BitArray([this._minLength = 0]) : _length = _minLength {
    reset();
  }

  static const _chunkSize = Uint32List.bytesPerElement * 8;
  static const _chunkIndexMask = _chunkSize - 1;

  static final _chunkIndexSize = _chunkIndexMask.setBitsAmount;

  static final _setMasks = List.generate(_chunkSize, (i) => 1 << i);
  static final _unsetMasks = List.generate(_chunkSize, (i) => ~(1 << i));

  final int _minLength;

  late Uint32List _chunks;

  int _length;

  int get length => _length;

  set length(int value) {
    _tryGrowFor(value - 1);
  }

  static int _getChunkIndex(int i) => i >> _chunkIndexSize;
  static int _getMaskIndex(int i) => i & _chunkIndexMask;

  bool operator [](int i) =>
      length > i &&
      _chunks[_getChunkIndex(i)] & _setMasks[_getMaskIndex(i)] != 0;

  void operator []=(int i, bool value) {
    (value ? setBit : unsetBit)(i);
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

  void _tryGrowFor(int i) {
    if (length > i) return;
    final chunks = Uint32List(_getChunkIndex(i) + 1);
    for (var j = 0; j < _chunks.length; j += 1) {
      chunks[j] = _chunks[j];
    }
    _chunks = chunks;
    _length = i + 1;
  }
}
