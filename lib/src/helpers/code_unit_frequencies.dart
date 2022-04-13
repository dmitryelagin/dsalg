extension CodeUnitFrequencies on String {
  Map<int, int> get codeUnitFrequencies {
    final counters = <int, int>{};
    for (final unit in codeUnits) {
      counters[unit] = (counters[unit] ?? 0) + 1;
    }
    return counters;
  }
}
