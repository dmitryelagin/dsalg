import 'dart:convert';

typedef RunLengthEntry = (int rune, int amount);

const runLengthCodec = RunLengthCodec._();

class RunLengthCodec extends Codec<String, List<RunLengthEntry>> {
  factory RunLengthCodec() => runLengthCodec;

  const RunLengthCodec._();

  @override
  RunLengthEncoder get encoder => const RunLengthEncoder();

  @override
  RunLengthDecoder get decoder => const RunLengthDecoder();
}

class RunLengthEncoder extends Converter<String, List<RunLengthEntry>> {
  const RunLengthEncoder();

  @override
  List<RunLengthEntry> convert(String input) {
    if (input.isEmpty) return [];
    final runes = input.runes, data = <RunLengthEntry>[];
    var last = runes.first, count = 1;
    for (final rune in runes.skip(1)) {
      if (rune == last) {
        count += 1;
      } else {
        data.add((last, count));
        last = rune;
        count = 1;
      }
    }
    return data..add((last, count));
  }
}

class RunLengthDecoder extends Converter<List<RunLengthEntry>, String> {
  const RunLengthDecoder();

  @override
  String convert(List<RunLengthEntry> input) {
    final buffer = StringBuffer();
    for (final (first, second) in input) {
      for (var i = 0; i < second; i += 1) {
        buffer.writeCharCode(first);
      }
    }
    return buffer.toString();
  }
}
