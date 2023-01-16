import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/base_cubit.dart';
import 'coherent_noise_interpolation_type.dart';
import 'coherent_noise_random_type.dart';
import 'coherent_noise_state.dart';
import 'limited_double_random.dart';

class CoherentNoiseCubit extends BaseCubit<CoherentNoiseState> {
  CoherentNoiseCubit({
    required int outputWidth,
    required int outputHeight,
    required String noiseSize,
  }) : super(CoherentNoiseState.initial(outputWidth, outputHeight)) {
    onChange.first.then((_) => updateSize(noiseSize));
  }

  void updateSize(String value) {
    final noiseSize = int.tryParse(value);
    if (noiseSize == null || noiseSize <= 0 || noiseSize == state.noiseSize) {
      return;
    }
    final noiseWidth = (state.outputWidth / noiseSize).ceil() + 1;
    final noiseHeight = (state.outputHeight / noiseSize).ceil() + 1;
    final noise =
        _generateNoise(noiseWidth: noiseWidth, noiseHeight: noiseHeight);
    final noiseInterpolated =
        _interpolateNoise(noise: noise, noiseSize: noiseSize);
    final noiseRendered = _renderNoise(noiseInterpolated: noiseInterpolated);
    add(
      CoherentNoiseState.from(
        state,
        noise: noise,
        noiseInterpolated: noiseInterpolated,
        noiseRendered: noiseRendered,
        noiseWidth: noiseWidth,
        noiseHeight: noiseHeight,
        noiseSize: noiseSize,
      ),
    );
  }

  void updateRandomType(CoherentNoiseRandomType type) {
    final random = _getRandom(type);
    final noise = _generateNoise(random: random);
    final noiseInterpolated = _interpolateNoise(noise: noise);
    final noiseRendered = _renderNoise(noiseInterpolated: noiseInterpolated);
    add(
      CoherentNoiseState.from(
        state,
        random: random,
        randomType: type,
        noise: noise,
        noiseInterpolated: noiseInterpolated,
        noiseRendered: noiseRendered,
      ),
    );
  }

  void updateInterpolationType(CoherentNoiseInterpolationType type) {
    if (type == state.interpolationType) return;
    final interpolator = _getInterpolator(type);
    final noiseInterpolated = _interpolateNoise(interpolator: interpolator);
    final noiseRendered = _renderNoise(noiseInterpolated: noiseInterpolated);
    add(
      CoherentNoiseState.from(
        state,
        interpolator: interpolator,
        interpolationType: type,
        noiseInterpolated: noiseInterpolated,
        noiseRendered: noiseRendered,
      ),
    );
  }

  void updateDynamicRangeCorrection({bool? shouldCorrectDynamicRange}) {
    final shouldCorrect =
        shouldCorrectDynamicRange ?? !state.shouldCorrectDynamicRange;
    final noiseRendered =
        _renderNoise(shouldCorrectDynamicRange: shouldCorrect);
    add(
      CoherentNoiseState.from(
        state,
        noiseRendered: noiseRendered,
        shouldCorrectDynamicRange: shouldCorrect,
      ),
    );
  }

  void updateTarget(Point<num> target) {
    if (target == state.target) return;
    add(CoherentNoiseState.from(state, target: target.toInt()));
  }

  List<List<num>> _generateNoise({
    Random? random,
    int? noiseWidth,
    int? noiseHeight,
  }) =>
      (random ?? state.random)
          .nextCoherent2DValueNoise(
            noiseWidth ?? state.noiseWidth,
            noiseHeight ?? state.noiseHeight,
          )
          .map(
            (list) => list
                .map((item) => item * CoherentNoiseState.baseAmplitude)
                .toList(),
          )
          .toList();

  List<List<num>> _interpolateNoise({
    Interpolator2D? interpolator,
    List<List<num>>? noise,
    int? outputWidth,
    int? outputHeight,
    int? noiseSize,
  }) {
    final actualInterpolator = interpolator ?? state.interpolator;
    final actualNoise = noise ?? state.noise;
    final actualSize = noiseSize ?? state.noiseSize;
    return List.generate(outputWidth ?? state.outputWidth, (x) {
      return List.generate(outputHeight ?? state.outputHeight, (y) {
        return actualInterpolator.interpolate(
          actualNoise,
          x / actualSize,
          y / actualSize,
        );
      });
    });
  }

  List<int> _renderNoise({
    List<List<num>>? noiseInterpolated,
    bool? shouldCorrectDynamicRange,
  }) =>
      (shouldCorrectDynamicRange ?? state.shouldCorrectDynamicRange)
          ? (noiseInterpolated ?? state.noiseInterpolated)
              .mapDynamicRangeToUint8List()
          : (noiseInterpolated ?? state.noiseInterpolated).toUint8ClampedList();

  Random _getRandom([CoherentNoiseRandomType? type]) {
    switch (type ?? state.randomType) {
      case CoherentNoiseRandomType.standard:
        return Random();
      case CoherentNoiseRandomType.limitedDouble:
        return const LimitedDoubleRandom(4);
    }
  }

  Interpolator2D _getInterpolator([CoherentNoiseInterpolationType? type]) {
    switch (type ?? state.interpolationType) {
      case CoherentNoiseInterpolationType.integer:
        return Interpolator2D.biInteger;
      case CoherentNoiseInterpolationType.linear:
        return Interpolator2D.biLinear;
      case CoherentNoiseInterpolationType.cubic:
        return Interpolator2D.biCubicCached();
      case CoherentNoiseInterpolationType.cubicS:
        return Interpolator2D.biCubicS;
      case CoherentNoiseInterpolationType.cosineS:
        return Interpolator2D.biCosineS;
      case CoherentNoiseInterpolationType.quinticS:
        return Interpolator2D.biQuinticS;
    }
  }
}
