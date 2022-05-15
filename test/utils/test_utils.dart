void repeat(void Function() callback, {required int times}) {
  for (var i = 0; i < times; i += 1) {
    callback();
  }
}

int measuredRepeat(void Function() callback, {required int times}) {
  final start = DateTime.now().millisecondsSinceEpoch;
  repeat(callback, times: times);
  final finish = DateTime.now().millisecondsSinceEpoch;
  return finish - start;
}
