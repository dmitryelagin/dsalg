extension IntFactorial on int {
  BigInt get factorial => BigInt.from(this).factorial;
}

extension BigIntFactorial on BigInt {
  BigInt get factorial {
    final target = abs();
    var result = isNegative ? -BigInt.one : BigInt.one;
    for (var i = BigInt.one; i <= target; i += BigInt.one) {
      result *= i;
    }
    return result;
  }
}
