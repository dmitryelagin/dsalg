import '../collections/queue.dart';

double lerp(num a, num b, double frac) {
  if (frac == 0 || a == b) return a.toDouble();
  if (frac == 1) return b.toDouble();
  return a * (1 - frac) + b * frac;
}

T lerpRecursive<T>(
  T Function(T, T, double) lerp,
  Iterable<T> items,
  double frac,
) {
  if (frac == 0) return items.first;
  if (frac == 1) return items.last;
  final queue = Queue(items);
  while (queue.length > 1) {
    final length = queue.length - 1;
    var previous = queue.extract();
    for (var i = 0; i < length; i += 1) {
      final current = queue.extract();
      queue.insert(lerp(previous, current, frac));
      previous = current;
    }
  }
  return queue.extract();
}
