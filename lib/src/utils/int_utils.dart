import 'dart:math';

extension IntUtils on int {
  int get lengthLogarithmic {
    if (this == 0) return 1;
    return (log(abs()) / ln10).floor() + 1;
  }

  int get lengthMultiplication {
    final current = abs();
    var length = 1, value = 10;
    while (value <= current) {
      length += 1;
      value *= 10;
    }
    return length;
  }

  int getDigit(int i) => abs() ~/ pow(10, i) % 10;
}
