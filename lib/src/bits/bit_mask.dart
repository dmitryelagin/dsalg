extension BitMask on int {
  Iterable<int> get bits sync* {
    for (var i = 0; i < bitLength; i += 1) {
      yield getBit(i);
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

  bool isSetBit(int i) => getBit(i) == 1;
  bool isUnsetBit(int i) => getBit(i) == 0;

  int getBit(int i) => this >> i & 1;
  int setBit(int i) => this | 1 << i;
  int unsetBit(int i) => this & ~(1 << i);
  int invertBit(int i) => this ^ 1 << i;

  int setBits(Iterable<int> indexes) => indexes.fold(this, _setBit);
  int unsetBits(Iterable<int> indexes) => indexes.fold(this, _unsetBit);
  int invertBits(Iterable<int> indexes) => indexes.fold(this, _invertBit);

  int _setBit(int n, int i) => n.setBit(i);
  int _unsetBit(int n, int i) => n.unsetBit(i);
  int _invertBit(int n, int i) => n.invertBit(i);
}
