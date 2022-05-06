import 'dart:convert';

import '../helpers/tuple.dart';

const runLengthCodec = RunLengthCodec._();

class RunLengthCodec extends Codec<String, List<MonoPair<int>>> {
  factory RunLengthCodec() => runLengthCodec;

  const RunLengthCodec._();

  @override
  RunLengthEncoder get encoder => const RunLengthEncoder();

  @override
  RunLengthDecoder get decoder => const RunLengthDecoder();
}

class RunLengthEncoder extends Converter<String, List<MonoPair<int>>> {
  const RunLengthEncoder();

  @override
  List<MonoPair<int>> convert(String input) {
    if (input.isEmpty) return [];
    final runes = input.runes, data = <MonoPair<int>>[];
    var last = runes.first, count = 1;
    for (final rune in runes.skip(1)) {
      if (rune == last) {
        count += 1;
      } else {
        data.add(Pair(last, count));
        last = rune;
        count = 1;
      }
    }
    return data..add(Pair(last, count));
  }
}

class RunLengthDecoder extends Converter<List<MonoPair<int>>, String> {
  const RunLengthDecoder();

  @override
  String convert(List<MonoPair<int>> input) {
    final buffer = StringBuffer();
    for (final item in input) {
      for (var i = 0; i < item.second; i += 1) {
        buffer.writeCharCode(item.first);
      }
    }
    return buffer.toString();
  }
}
