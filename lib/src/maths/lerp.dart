import '../collections/queue.dart';

double lerp(num a, num b, double t) {
  if (t == 0 || a == b) return a.toDouble();
  if (t == 1) return b.toDouble();
  return a * (1 - t) + b * t;
}

T lerpRecursive<T>(T Function(T, T, double) lerp, Iterable<T> items, double t) {
  if (t == 0) return items.first;
  if (t == 1) return items.last;
  final queue = Queue(items);
  while (queue.length > 1) {
    final length = queue.length - 1;
    var previous = queue.extract();
    for (var i = 0; i < length; i += 1) {
      final current = queue.extract();
      queue.insert(lerp(previous, current, t));
      previous = current;
    }
  }
  return queue.extract();
}
