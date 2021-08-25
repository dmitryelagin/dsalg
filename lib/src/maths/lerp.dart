double lerp(num a, num b, double t) =>
    a == b ? a.toDouble() : a * (1 - t) + b * t;
