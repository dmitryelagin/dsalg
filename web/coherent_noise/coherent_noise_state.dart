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
    required this.noiseWidth,
    required this.noiseHeight,
    required this.noiseSize,
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
    int? noiseWidth,
    int? noiseHeight,
    int? noiseSize,
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
        noiseWidth: noiseWidth ?? state.noiseWidth,
        noiseHeight: noiseHeight ?? state.noiseHeight,
        noiseSize: noiseSize ?? state.noiseSize,
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
        noiseWidth: 0,
        noiseHeight: 0,
        noiseSize: 0,
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

  final int noiseWidth, noiseHeight, noiseSize, outputWidth, outputHeight;

  final Interpolator2D interpolator;

  final CoherentNoiseInterpolationType interpolationType;

  final bool shouldCorrectDynamicRange;

  final Point<int> target;

  List<num> get noiseHorizontal {
    final actualY = (target.y / noiseSize).round();
    return noise[actualY];
  }

  List<num> get noiseVertical {
    final actualX = (target.x / noiseSize).round();
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
