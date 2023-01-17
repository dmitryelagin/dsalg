import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/base_bloc.dart';
import '../utils/limited_double_random.dart';
import 'coherent_noise_bloc_events.dart';
import 'coherent_noise_interpolation_type.dart';
import 'coherent_noise_random_type.dart';
import 'coherent_noise_state.dart';

class CoherentNoiseBloc
    extends BaseBloc<CoherentNoiseState, CoherentNoiseBlocEvent> {
  CoherentNoiseBloc(int outputWidth, int outputHeight)
      : super(CoherentNoiseState.initial(outputWidth, outputHeight)) {
    on(_updateSize);
    on(_updateRandomType);
    on(_updateInterpolationType);
    on(_updateDynamicRangeCorrection);
    on(_updateTarget);
  }

  void _updateSize(
    void Function(CoherentNoiseState) change,
    UpdateSize event,
  ) {
    final noiseSize = int.tryParse(event.value);
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
    change(
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

  void _updateRandomType(
    void Function(CoherentNoiseState) change,
    UpdateRandomType event,
  ) {
    final random = _getRandom(event.type);
    final noise = _generateNoise(random: random);
    final noiseInterpolated = _interpolateNoise(noise: noise);
    final noiseRendered = _renderNoise(noiseInterpolated: noiseInterpolated);
    change(
      CoherentNoiseState.from(
        state,
        random: random,
        randomType: event.type,
        noise: noise,
        noiseInterpolated: noiseInterpolated,
        noiseRendered: noiseRendered,
      ),
    );
  }

  void _updateInterpolationType(
    void Function(CoherentNoiseState) change,
    UpdateInterpolationType event,
  ) {
    if (event.type == state.interpolationType) return;
    final interpolator = _getInterpolator(event.type);
    final noiseInterpolated = _interpolateNoise(interpolator: interpolator);
    final noiseRendered = _renderNoise(noiseInterpolated: noiseInterpolated);
    change(
      CoherentNoiseState.from(
        state,
        interpolator: interpolator,
        interpolationType: event.type,
        noiseInterpolated: noiseInterpolated,
        noiseRendered: noiseRendered,
      ),
    );
  }

  void _updateDynamicRangeCorrection(
    void Function(CoherentNoiseState) change,
    UpdateDynamicRangeCorrection event,
  ) {
    final shouldCorrect =
        event.shouldCorrectDynamicRange ?? !state.shouldCorrectDynamicRange;
    final noiseRendered =
        _renderNoise(shouldCorrectDynamicRange: shouldCorrect);
    change(
      CoherentNoiseState.from(
        state,
        noiseRendered: noiseRendered,
        shouldCorrectDynamicRange: shouldCorrect,
      ),
    );
  }

  void _updateTarget(
    void Function(CoherentNoiseState) change,
    UpdateTarget event,
  ) {
    if (event.target == state.target) return;
    change(CoherentNoiseState.from(state, target: event.target.toInt()));
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
