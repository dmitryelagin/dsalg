bool Function(X) not<X>(bool Function(X) fn) => (x) => !fn(x);

X Function(Object?) unary<X>(X Function() fn) => (_) => fn();

Y? Function(X?) maybe<X, Y>(Y Function(X) fn) =>
    (x) => x == null ? null : fn(x);

X? Function() once<X>(X Function() fn) {
  var isDone = false;
  return () {
    if (isDone) return null;
    isDone = true;
    return fn();
  };
}

Null Function(X) nothing<X>(void Function(X) fn) => (x) {
      fn(x);
    };
