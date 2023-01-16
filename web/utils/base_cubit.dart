import 'dart:async';

abstract class BaseCubit<S> {
  BaseCubit(S initialState) {
    _onChange = StreamController.broadcast(
      onListen: () => onChange.listen((state) => _state = state),
    );
    add(initialState);
  }

  late S _state;

  late StreamController<S> _onChange;

  S get state => _state;

  Stream<S> get onChange => _onChange.stream;

  void add(S state) {
    _onChange.add(state);
  }

  void close() {
    _onChange.close();
  }
}
