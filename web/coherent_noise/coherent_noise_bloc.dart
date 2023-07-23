import 'dart:math';

import 'package:dsalg/dsalg.dart';

import '../utils/base_bloc.dart';
import '../utils/limited_double_random.dart';
import 'coherent_noise_bloc_events.dart';
import 'coherent_noise_interpolation_type.dart';
import 'coherent_noise_random_type.dart';
import 'coherent_noise_render_helper.dart';
import 'coherent_noise_state.dart';

class CoherentNoiseBloc
    extends BaseBloc<CoherentNoiseState, CoherentNoiseBlocEvent> {
  CoherentNoiseBloc(int outputWidth, int outputHeight)
      : super(CoherentNoiseState.initial(outputWidth, outputHeight)) {
    on(_updateAmount);
    on(_updateRandomType);
    on(_updateInterpolationType);
    on(_updateDynamicRangeCorrection);
    on(_updateTarget);
  }

  void _updateAmount(
    BlocStateChange<CoherentNoiseState> change,
    UpdateAmount event,
  ) {
    final noiseAmount = int.tryParse(event.value);
    if (noiseAmount == null ||
        noiseAmount <= 1 ||
        noiseAmount == state.noiseAmount) {
      change();
    } else {
      final noise = _generateNoise(noiseAmount: noiseAmount);
      final noiseInterpolated =
          _interpolateNoise(noise: noise, noiseAmount: noiseAmount);
      final noiseRendered = _renderNoise(noiseInterpolated: noiseInterpolated);
      change(
        CoherentNoiseState.from(
          state,
          noise: noise,
          noiseInterpolated: noiseInterpolated,
          noiseRendered: noiseRendered,
          noiseAmount: noiseAmount,
        ),
      );
    }
  }

  void _updateRandomType(
    BlocStateChange<CoherentNoiseState> change,
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
    BlocStateChange<CoherentNoiseState> change,
    UpdateInterpolationType event,
  ) {
    if (event.type == state.interpolationType) {
      change();
    } else {
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
  }

  void _updateDynamicRangeCorrection(
    BlocStateChange<CoherentNoiseState> change,
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
    BlocStateChange<CoherentNoiseState> change,
    UpdateTarget event,
  ) {
    if (event.target != state.target) {
      change(CoherentNoiseState.from(state, target: event.target.toInt()));
    } else {
      change();
    }
  }

  List<List<num>> _generateNoise({Random? random, int? noiseAmount}) {
    final actualNoiseAmount = (noiseAmount ?? state.noiseAmount) + 1;
    return (random ?? state.random)
        .nextCoherent2DValueNoise(actualNoiseAmount, actualNoiseAmount)
        .map(
          (list) => list
              .map((item) => item * CoherentNoiseRenderHelper.baseAmplitude)
              .toList(),
        )
        .toList();
  }

  List<List<num>> _interpolateNoise({
    Interpolator2D? interpolator,
    List<List<num>>? noise,
    int? noiseAmount,
  }) {
    final actualInterpolator = interpolator ?? state.interpolator;
    final actualNoise = noise ?? state.noise;
    final actualNoiseAmount = noiseAmount ?? state.noiseAmount;
    final actualNoiseWidth = state.outputWidth / actualNoiseAmount;
    final actualNoiseHeight = state.outputHeight / actualNoiseAmount;
    return List.generate(state.outputHeight, (y) {
      return List.generate(state.outputWidth, (x) {
        return actualInterpolator.interpolate(
          actualNoise,
          y / actualNoiseHeight,
          x / actualNoiseWidth,
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

  Random _getRandom([CoherentNoiseRandomType? type]) =>
      switch (type ?? state.randomType) {
        CoherentNoiseRandomType.standard => Random(),
        CoherentNoiseRandomType.limitedDouble => const LimitedDoubleRandom(4),
      };

  Interpolator2D _getInterpolator([CoherentNoiseInterpolationType? type]) =>
      switch (type ?? state.interpolationType) {
        CoherentNoiseInterpolationType.integer => Interpolator2D.biInteger,
        CoherentNoiseInterpolationType.linear => Interpolator2D.biLinear,
        CoherentNoiseInterpolationType.cubic => Interpolator2D.biCubicCached(),
        CoherentNoiseInterpolationType.cubicS => Interpolator2D.biCubicS,
        CoherentNoiseInterpolationType.cosineS => Interpolator2D.biCosineS,
        CoherentNoiseInterpolationType.quinticS => Interpolator2D.biQuinticS,
      };
}
