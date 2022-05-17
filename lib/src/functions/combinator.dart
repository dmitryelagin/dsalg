// ignore_for_file: avoid_types_on_closure_parameters
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: library_private_types_in_public_api

import 'decorator.dart';

typedef _FU<X, Y> = Y Function(X);

// I Combinator
final identity = <X>(X x) => x;

// K Combinator
final kestrel = <X>(X x) => <Y>(Y y) => x;

// V Combinator
final vireo = <X>(X x) => <Y>(Y y) => <Z>(_FU<X, _FU<Y, Z>> fn) => fn(x)(y);

// ---

final tap = <X>(X x) => (_FU<X, void> fn) => nothing(fn)(x) ?? x;

final compose =
    <Y, Z>(_FU<Y, Z> fnYZ) => <X>(_FU<X, Y> fnXY) => (X x) => fnYZ(fnXY(x));

final composeAll = <X>(Iterable<_FU<X, X>> fns) =>
    (X x) => fns.toList().reversed.fold(x, (x, fn) => fn(x));

final pipeline =
    <X, Y>(_FU<X, Y> fnXY) => <Z>(_FU<Y, Z> fnYZ) => (X x) => fnYZ(fnXY(x));

final pipelineAll =
    <X>(Iterable<X Function(X)> fns) => (X x) => fns.fold(x, (x, fn) => fn(x));

// ---

final first = kestrel;
final second = kestrel(identity);
final pair = vireo;

void main() {
  final data = pair(1)('a');
  // final firstValue = data(first);
  // final secondValue = data(second);
  final firstValue = data((x) => (y) => x);
  final secondValue = data((x) => (y) => y);
}
