extension LinearSearch<T> on List<T> {
  int linearSearch(bool Function(T) isRequired) {
    for (var i = 0; i < length; i += 1) {
      if (isRequired(this[i])) return i;
    }
    return -1;
  }
}
