import 'dart:math';

import 'coherent_noise_interpolation_type.dart';
import 'coherent_noise_random_type.dart';

abstract class CoherentNoiseBlocEvent {}

class UpdateSize implements CoherentNoiseBlocEvent {
  const UpdateSize(this.value);

  final String value;
}

class UpdateRandomType implements CoherentNoiseBlocEvent {
  const UpdateRandomType(this.type);

  static const standard = UpdateRandomType(CoherentNoiseRandomType.standard);
  static const limitedDouble =
      UpdateRandomType(CoherentNoiseRandomType.limitedDouble);

  final CoherentNoiseRandomType type;
}

class UpdateInterpolationType implements CoherentNoiseBlocEvent {
  const UpdateInterpolationType(this.type);

  static const integer =
      UpdateInterpolationType(CoherentNoiseInterpolationType.integer);
  static const linear =
      UpdateInterpolationType(CoherentNoiseInterpolationType.linear);
  static const cubic =
      UpdateInterpolationType(CoherentNoiseInterpolationType.cubic);
  static const cubicS =
      UpdateInterpolationType(CoherentNoiseInterpolationType.cubicS);
  static const cosineS =
      UpdateInterpolationType(CoherentNoiseInterpolationType.cosineS);
  static const quinticS =
      UpdateInterpolationType(CoherentNoiseInterpolationType.quinticS);

  final CoherentNoiseInterpolationType type;
}

class UpdateDynamicRangeCorrection implements CoherentNoiseBlocEvent {
  const UpdateDynamicRangeCorrection({required this.shouldCorrectDynamicRange});

  final bool? shouldCorrectDynamicRange;
}

class UpdateTarget implements CoherentNoiseBlocEvent {
  const UpdateTarget(this.target);

  final Point<num> target;
}
