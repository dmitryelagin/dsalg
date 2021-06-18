import 'dart:math';

extension IntUtils on int {
  int get length => this == 0 ? 1 : (log(abs()) / ln10).floor() + 1;

  int getDigit(int i) => abs() ~/ pow(10, i) % 10;
}
