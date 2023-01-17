import 'dart:math';

import 'package:dsalg/dsalg.dart';

import 'coherent_noise_interpolation_type.dart';
import 'coherent_noise_random_type.dart';

class CoherentNoiseState {
  const CoherentNoiseState({
    required this.random,
    required this.randomType,
    required this.noise,
    required this.noiseInterpolated,
    required this.noiseRendered,
    required this.noiseAmount,
    required this.outputWidth,
    required this.outputHeight,
    required this.interpolator,
    required this.interpolationType,
    required this.shouldCorrectDynamicRange,
    required this.target,
  });

  factory CoherentNoiseState.from(
    CoherentNoiseState state, {
    Random? random,
    CoherentNoiseRandomType? randomType,
    List<List<num>>? noise,
    List<List<num>>? noiseInterpolated,
    List<int>? noiseRendered,
    int? noiseAmount,
    int? outputWidth,
    int? outputHeight,
    Interpolator2D? interpolator,
    CoherentNoiseInterpolationType? interpolationType,
    bool? shouldCorrectDynamicRange,
    Point<int>? target,
  }) =>
      CoherentNoiseState(
        random: random ?? state.random,
        randomType: randomType ?? state.randomType,
        noise: noise ?? state.noise,
        noiseInterpolated: noiseInterpolated ?? state.noiseInterpolated,
        noiseRendered: noiseRendered ?? state.noiseRendered,
        noiseAmount: noiseAmount ?? state.noiseAmount,
        outputWidth: outputWidth ?? state.outputWidth,
        outputHeight: outputHeight ?? state.outputHeight,
        interpolator: interpolator ?? state.interpolator,
        interpolationType: interpolationType ?? state.interpolationType,
        shouldCorrectDynamicRange:
            shouldCorrectDynamicRange ?? state.shouldCorrectDynamicRange,
        target: target ?? state.target,
      );

  factory CoherentNoiseState.initial(int outputWidth, int outputHeight) =>
      CoherentNoiseState(
        random: Random(),
        randomType: CoherentNoiseRandomType.standard,
        noise: [],
        noiseInterpolated: [],
        noiseRendered: [],
        noiseAmount: 0,
        outputWidth: outputWidth,
        outputHeight: outputHeight,
        interpolator: Interpolator2D.biInteger,
        interpolationType: CoherentNoiseInterpolationType.integer,
        shouldCorrectDynamicRange: false,
        target: const Point(0, 0),
      );

  final Random random;

  final CoherentNoiseRandomType randomType;

  final List<List<num>> noise, noiseInterpolated;

  final List<int> noiseRendered;

  final int noiseAmount, outputWidth, outputHeight;

  final Interpolator2D interpolator;

  final CoherentNoiseInterpolationType interpolationType;

  final bool shouldCorrectDynamicRange;

  final Point<int> target;

  double get noiseWidth => outputWidth / noiseAmount;
  double get noiseHeight => outputHeight / noiseAmount;

  List<num> get noiseHorizontal {
    final actualY = (target.y / noiseHeight).round();
    return noise[actualY];
  }

  List<num> get noiseVertical {
    final actualX = (target.x / noiseWidth).round();
    return noise.map((list) => list[actualX]).toList();
  }

  List<num> get noiseInterpolatedHorizontal => noiseInterpolated[target.y];

  List<num> get noiseInterpolatedVertical =>
      noiseInterpolated.map((list) => list[target.x]).toList();

  List<int> get noiseRenderedHorizontal => [
        for (var i = target.y * outputWidth;
            i < (target.y + 1) * outputWidth;
            i += 1)
          noiseRendered[i],
      ];

  List<int> get noiseRenderedVertical => [
        for (var i = target.x;
            i < outputWidth * outputHeight - target.x;
            i += outputWidth)
          noiseRendered[i],
      ];
}
