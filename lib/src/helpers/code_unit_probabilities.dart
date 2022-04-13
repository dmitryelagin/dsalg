import 'code_unit_frequencies.dart';

extension CodeUnitProbabilities on String {
  Map<int, double> get codeUnitProbabilities => {
        for (final entry in codeUnitFrequencies.entries)
          entry.key: entry.value / length,
      };
}
