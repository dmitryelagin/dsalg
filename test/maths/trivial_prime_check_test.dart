import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  group('TrivialPrimeCheck', () {
    test('should properly check if number is prime', () {
      final items = List.generate(101, (index) => index - 1);
      expect(items.where((item) => item.isPrimeTrivial), [
        ...[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59],
        ...[61, 67, 71, 73, 79, 83, 89, 97],
      ]);
    });
  });
}
