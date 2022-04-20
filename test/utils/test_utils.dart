void repeat(void Function() callback, {required int times}) {
  for (var i = 0; i < times; i += 1) {
    callback();
  }
}
