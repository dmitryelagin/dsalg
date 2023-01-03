import 'dart:convert';

const runLengthCodec = RunLengthCodec._();

class RunLengthCodec extends Codec<String, List<(int, int)>> {
  factory RunLengthCodec() => runLengthCodec;

  const RunLengthCodec._();

  @override
  RunLengthEncoder get encoder => const RunLengthEncoder();

  @override
  RunLengthDecoder get decoder => const RunLengthDecoder();
}

class RunLengthEncoder extends Converter<String, List<(int, int)>> {
  const RunLengthEncoder();

  @override
  List<(int, int)> convert(String input) {
    if (input.isEmpty) return [];
    final runes = input.runes, data = <(int, int)>[];
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

class RunLengthDecoder extends Converter<List<(int, int)>, String> {
  const RunLengthDecoder();

  @override
  String convert(List<(int, int)> input) {
    final buffer = StringBuffer();
    for (final (char, count) in input) {
      for (var i = 0; i < count; i += 1) {
        buffer.writeCharCode(char);
      }
    }
    return buffer.toString();
  }
}
