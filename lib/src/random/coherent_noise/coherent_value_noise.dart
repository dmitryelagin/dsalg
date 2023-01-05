import 'dart:math';

import '../../helpers/caching_iterable.dart';

extension CoherentValueNoise on Random {
  Iterable<double> nextCoherentValueNoise(int length) =>
      CachingIterable(length, _nextDoubleUnary);

  Iterable<Iterable<double>> nextCoherent2DValueNoise(int width, int height) =>
      CachingIterable(width, (_) => nextCoherentValueNoise(height));

  double _nextDoubleUnary(Object _) => nextDouble();
}
