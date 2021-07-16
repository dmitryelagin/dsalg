extension BitMask on int {
  Iterable<int> get bits sync* {
    for (var i = 0; i < bitLength; i += 1) {
      yield this[i];
    }
  }

  int get setBitsAmount {
    var i = this, count = 0;
    while (i > 0) {
      i &= i - 1;
      count += 1;
    }
    return count;
  }

  int get unsetBitsAmount => bitLength - setBitsAmount;

  int operator [](int i) => this >> i & 1;

  bool isSetBit(int i) => this[i] == 1;
  bool isUnsetBit(int i) => this[i] == 0;

  int setBit(int i) => this | 1 << i;
  int unsetBit(int i) => this & ~(1 << i);
  int invertBit(int i) => this ^ 1 << i;

  int setBits(Iterable<int> indexes) => indexes.fold(this, _setBit);
  int unsetBits(Iterable<int> indexes) => indexes.fold(this, _unsetBit);
  int invertBits(Iterable<int> indexes) => indexes.fold(this, _invertBit);

  int _setBit(int number, int i) => number.setBit(i);
  int _unsetBit(int number, int i) => number.unsetBit(i);
  int _invertBit(int number, int i) => number.invertBit(i);
}
