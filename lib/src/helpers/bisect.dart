import '../utils/functions.dart';

extension Bisect<T> on List<T> {
  (Iterable<T>, Iterable<T>) bisectByMass(num Function(T) getItemMass) {
    assert(length > 1);
    num getMass(int index) {
      final mass = getItemMass(this[index]);
      assert(mass > 0);
      return mass;
    }

    var leftIndex = 0, rightIndex = length - 1;
    var leftMass = getMass(leftIndex), rightMass = getMass(rightIndex);
    while (leftIndex + 1 < rightIndex) {
      final nextLeftMass = leftMass + getMass(leftIndex + 1);
      final nextRightMass = rightMass + getMass(rightIndex - 1);
      if ((rightMass - nextLeftMass).abs() < (leftMass - nextRightMass).abs()) {
        leftMass = nextLeftMass;
        leftIndex += 1;
      } else {
        rightMass = nextRightMass;
        rightIndex -= 1;
      }
    }
    return (getRange(0, rightIndex), getRange(rightIndex, length));
  }
}

extension BisectNum<T extends num> on List<T> {
  (Iterable<T>, Iterable<T>) bisectByMass([num Function(T)? getItemMass]) =>
      Bisect(this).bisectByMass(getItemMass ?? identity);
}
