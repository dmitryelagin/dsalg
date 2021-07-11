extension TrivialPrimeCheck on int {
  bool get isPrimeTrivial {
    if (this < 4) return this > 1;
    if (isEven || this % 3 == 0) return false;
    for (var i = 5; i * i <= this; i += 6) {
      if (this % i == 0 || this % (i + 2) == 0) return false;
    }
    return true;
  }
}
