import 'dart:typed_data';

extension Convert1DNumIterable on Iterable<num> {
  Uint8List toUint8List() => _toList(Uint8List.new);
  Uint8ClampedList toUint8ClampedList() => _toList(Uint8ClampedList.new);

  T _toList<T extends List<int>>(T Function(int) getList) {
    final target = getList(length);
    var i = -1;
    for (final item in this) {
      target[i += 1] = item.toInt();
    }
    return target;
  }
}

extension Convert2DNumIterable on Iterable<Iterable<num>> {
  Uint8List toUint8List() => _toList(Uint8List.new);
  Uint8ClampedList toUint8ClampedList() => _toList(Uint8ClampedList.new);

  T _toList<T extends List<int>>(T Function(int) getList) {
    final target = getList(fold(0, (sum, list) => sum + list.length));
    var i = -1;
    for (final list in this) {
      for (final item in list) {
        target[i += 1] = item.toInt();
      }
    }
    return target;
  }
}
