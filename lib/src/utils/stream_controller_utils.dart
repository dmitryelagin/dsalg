import 'dart:async';

extension StreamControllerUtils<T> on StreamController<T> {
  void addAll(Iterable<T> items) {
    items.forEach(add);
  }
}
