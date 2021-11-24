import 'dart:typed_data';

class BitArray {
  BitArray([this._minLength = 0]) {
    reset();
  }

  static const _chunkSize = Uint32List.bytesPerElement * 8;
  static const _chunkIndexMask = _chunkSize - 1;

  final _setMask = List.generate(_chunkSize, (i) => 1 << i);
  final _unsetMask = List.generate(_chunkSize, (i) => ~(1 << i));

  final int _minLength;

  late Uint32List _chunks;

  int get length => _chunks.length * _chunkSize;

  static int _getChunkIndex(int i) => i >> 5;

  bool operator [](int i) =>
      _chunks[_getChunkIndex(i)] & _setMask[i & _chunkIndexMask] != 0;

  bool isSetBit(int i) => this[i];
  bool isUnsetBit(int i) => !this[i];

  void setBit(int i) {
    tryGrowFor(i);
    _chunks[_getChunkIndex(i)] |= _setMask[i & _chunkIndexMask];
  }

  void unsetBit(int i) {
    tryGrowFor(i);
    _chunks[_getChunkIndex(i)] &= _unsetMask[i & _chunkIndexMask];
  }

  void invertBit(int i) {
    tryGrowFor(i);
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
