import 'dart:math';

import '../../helpers/caching_iterable.dart';

extension CoherentValueNoise on Random {
  Iterable<double> nextCoherent1DValueNoise(int length) =>
      CachingIterable(length, _nextDoubleUnary);

  Iterable<Iterable<double>> nextCoherent2DValueNoise(int width, int height) =>
      CachingIterable(width, (_) => nextCoherent1DValueNoise(height));

  double _nextDoubleUnary(Object _) => nextDouble();
}
