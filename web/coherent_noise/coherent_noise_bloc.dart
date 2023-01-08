import 'dart:async';
import 'dart:math';

import 'package:dsalg/dsalg.dart';

import 'coherent_noise_interpolation_type.dart';
import 'coherent_noise_random_type.dart';
import 'coherent_noise_state.dart';
import 'limited_double_random.dart';

class CoherentNoiseBloc {
  CoherentNoiseBloc({
    required int outputWidth,
    required int outputHeight,
    required String noiseSize,
  }) {
    _state = CoherentNoiseState.initial(outputWidth, outputHeight);
    _onChange = StreamController.broadcast(
      onListen: () {
        onChange.listen((state) => _state = state);
        updateSize(noiseSize);
      },
    );
  }

  late CoherentNoiseState _state;

  late StreamController<CoherentNoiseState> _onChange;

  Stream<CoherentNoiseState> get onChange => _onChange.stream;

  void updateSize(String value) {
    final noiseSize = int.tryParse(value);
    if (noiseSize == null || noiseSize <= 0 || noiseSize == _state.noiseSize) {
      return;
    }
    final noiseWidth = (_state.outputWidth / noiseSize).ceil() + 1;
    final noiseHeight = (_state.outputHeight / noiseSize).ceil() + 1;
    final noise =
        _generateNoise(noiseWidth: noiseWidth, noiseHeight: noiseHeight);
    final noiseInterpolated =
        _interpolateNoise(noise: noise, noiseSize: noiseSize);
    final noiseRendered = _renderNoise(noiseInterpolated: noiseInterpolated);
    _onChange.add(
      CoherentNoiseState.from(
        _state,
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
    _onChange.add(
      CoherentNoiseState.from(
        _state,
        random: random,
        randomType: type,
        noise: noise,
        noiseInterpolated: noiseInterpolated,
        noiseRendered: noiseRendered,
      ),
    );
  }

  void updateInterpolationType(CoherentNoiseInterpolationType type) {
    if (type == _state.interpolationType) return;
    final interpolator = _getInterpolator(type);
    final noiseInterpolated = _interpolateNoise(interpolator: interpolator);
    final noiseRendered = _renderNoise(noiseInterpolated: noiseInterpolated);
    _onChange.add(
      CoherentNoiseState.from(
        _state,
        interpolator: interpolator,
        interpolationType: type,
        noiseInterpolated: noiseInterpolated,
        noiseRendered: noiseRendered,
      ),
    );
  }

  void updateDynamicRangeCorrection({bool? shouldCorrectDynamicRange}) {
    final shouldCorrect =
        shouldCorrectDynamicRange ?? !_state.shouldCorrectDynamicRange;
    final noiseRendered =
        _renderNoise(shouldCorrectDynamicRange: shouldCorrect);
    _onChange.add(
      CoherentNoiseState.from(
        _state,
        noiseRendered: noiseRendered,
        shouldCorrectDynamicRange: shouldCorrect,
      ),
    );
  }

  void updateTarget(Point<num> target) {
    if (target == _state.target) return;
    _onChange.add(CoherentNoiseState.from(_state, target: target.toInt()));
  }

  List<List<num>> _generateNoise({
    Random? random,
    int? noiseWidth,
    int? noiseHeight,
  }) =>
      (random ?? _state.random)
          .nextCoherent2DValueNoise(
            noiseWidth ?? _state.noiseWidth,
            noiseHeight ?? _state.noiseHeight,
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
    final actualInterpolator = interpolator ?? _state.interpolator;
    final actualNoise = noise ?? _state.noise;
    final actualSize = noiseSize ?? _state.noiseSize;
    return List.generate(outputWidth ?? _state.outputWidth, (x) {
      return List.generate(outputHeight ?? _state.outputHeight, (y) {
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
      (shouldCorrectDynamicRange ?? _state.shouldCorrectDynamicRange)
          ? (noiseInterpolated ?? _state.noiseInterpolated)
              .mapDynamicRangeToUint8List()
          : (noiseInterpolated ?? _state.noiseInterpolated)
              .toUint8ClampedList();

  Random _getRandom([CoherentNoiseRandomType? type]) {
    switch (type ?? _state.randomType) {
      case CoherentNoiseRandomType.standard:
        return Random();
      case CoherentNoiseRandomType.limitedDouble:
        return const LimitedDoubleRandom(4);
    }
  }

  Interpolator2D _getInterpolator([CoherentNoiseInterpolationType? type]) {
    switch (type ?? _state.interpolationType) {
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
