extension MapUtils<K, V> on Map<K, V> {
  Map<V, K> get opposite => {for (final key in keys) this[key] as V: key};
}
