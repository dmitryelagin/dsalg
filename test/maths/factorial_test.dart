import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

void main() {
  group('Factorial', () {
    test('should return correct factorial of a number', () {
      expect(0.factorial, BigInt.one);
      expect(1.factorial, BigInt.one);
      expect(2.factorial, BigInt.two);
      expect(3.factorial, BigInt.from(6));
      expect(4.factorial, BigInt.from(24));
      expect(6.factorial, BigInt.from(720));
      expect(10.factorial, BigInt.from(3628800));
      expect(20.factorial, BigInt.from(2432902008176640000));
      expect(
        50.factorial,
        BigInt.parse(
          '30414093201713378043612608166064768844377641568960512000000000000',
        ),
      );
    });
  });
}
