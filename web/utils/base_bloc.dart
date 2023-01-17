import 'dart:async';

typedef BlocStateChange<S> = void Function([S?]);
typedef BlocTransformer<S, T> = void Function(BlocStateChange<S>, T);

class StateChanged<S> {
  const StateChanged(this.state, [this.processDuration = 0]);

  final S state;
  final int processDuration;
}

abstract class BaseBloc<S, E> {
  BaseBloc(this._state);

  S _state;
  int? _start;

  final _onAdd = StreamController<E>.broadcast();
  final _onChange = StreamController<StateChanged<S>>.broadcast();

  S get state => _state;

  Stream<StateChanged<S>> get onChange => _onChange.stream;

  void on<T extends E>(BlocTransformer<S, T> transform) {
    _onAdd.stream.listen((event) {
      if (event is T) transform(_change, event);
    });
  }

  void add<T extends E>(T event) {
    _start ??= _now();
    _onAdd.add(event);
  }

  void close() {
    _onAdd.close();
    _onChange.close();
  }

  void _change([S? state]) {
    if (state == null || _state == state) {
      _start = null;
      return;
    }
    _state = state;
    if (_start != null) {
      _onChange.add(StateChanged(state, _now() - _start!));
      _start = null;
    } else {
      _onChange.add(StateChanged(state));
    }
  }

  int _now() => DateTime.now().millisecondsSinceEpoch;
}
