import 'dart:async';

abstract class BaseCubit<S> {
  BaseCubit(this._state);

  S _state;

  final _onChange = StreamController<S>.broadcast();

  S get state => _state;

  Stream<S> get onChange => _onChange.stream;

  void change(S state) {
    _state = state;
    _onChange.add(state);
  }

  void close() {
    _onChange.close();
  }
}
