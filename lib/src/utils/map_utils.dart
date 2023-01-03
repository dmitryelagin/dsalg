extension MapUtils<K, V> on Map<K, V> {
  V get(K key) => this[key]!;
  V? tryGet(K key) => this[key];
  Map<V, K> get opposite => {for (final key in keys) this[key] as V: key};
}
