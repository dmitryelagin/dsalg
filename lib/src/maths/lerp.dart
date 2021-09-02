double lerp(num a, num b, double t) {
  if (t == 0 || a == b) return a.toDouble();
  if (t == 1) return b.toDouble();
  return a * (1 - t) + b * t;
}
