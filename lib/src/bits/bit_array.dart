import 'dart:typed_data';

import 'bit_mask.dart';

class BitArray {
  BitArray([this._minLength = 0]) {
    reset();
  }

  static const _chunkSize = Uint32List.bytesPerElement * 8;

  final int _minLength;

  late Uint32List _chunks;

  int get length => _chunks.length * _chunkSize;

  static int _getChunkIndex(int i) => i ~/ _chunkSize;
  static int _getChunkBit(int i) => i % _chunkSize;

  int operator [](int i) =>
      i < length ? _chunks[_getChunkIndex(i)][_getChunkBit(i)] : 0;

  bool isSetBit(int i) => this[i] == 1;
  bool isUnsetBit(int i) => this[i] == 0;

  void setBit(int i) {
    tryGrowFor(i);
    final chunkIndex = _getChunkIndex(i);
    _chunks[chunkIndex] = _chunks[chunkIndex].setBit(_getChunkBit(i));
  }

  void unsetBit(int i) {
    tryGrowFor(i);
    final chunkIndex = _getChunkIndex(i);
    _chunks[chunkIndex] = _chunks[chunkIndex].unsetBit(_getChunkBit(i));
  }

  void invertBit(int i) {
    tryGrowFor(i);
    final chunkIndex = _getChunkIndex(i);
    _chunks[chunkIndex] = _chunks[chunkIndex].invertBit(_getChunkBit(i));
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
    _chunks = Uint32List(_minLength);
  }

  void tryGrowFor(int i) {
    if (length > i) return;
    final chunks = Uint32List(_getChunkIndex(i) + 1);
    for (var j = 0; j < _chunks.length; j += 1) {
      chunks[j] = _chunks[j];
    }
    _chunks = chunks;
  }
}
