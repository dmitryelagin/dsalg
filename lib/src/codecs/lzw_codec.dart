import 'dart:async';
import 'dart:convert';

import '../utils/stream_controller_utils.dart';

const lzwCodec = LzwCodec._();

class LzwCodec extends Encoding {
  factory LzwCodec() => lzwCodec;

  const LzwCodec._();

  static final _initialDictionary = {
    for (final i in List.generate(256, (i) => i)) String.fromCharCode(i): i,
  };

  @override
  String get name => 'lzw';

  @override
  LzwEncoder get encoder => const LzwEncoder();

  @override
  LzwDecoder get decoder => const LzwDecoder();
}

class LzwEncoder extends Converter<String, List<int>> {
  const LzwEncoder();

  static StreamTransformer<String, int> encodeTransformer() =>
      StreamTransformer.fromBind((stream) {
        return stream
            .expand(utf8.encode)
            .map(String.fromCharCode)
            .transform(encodeUtf8CharTransformer());
      });

  static StreamTransformer<String, int> encodeUtf8CharTransformer() {
    final dictionary = Map.of(LzwCodec._initialDictionary);
    var word = '';
    return StreamTransformer.fromHandlers(
      handleData: (char, sink) {
        final extendedWord = word + char;
        if (dictionary.containsKey(extendedWord)) {
          word = extendedWord;
        } else {
          sink.add(dictionary[word]!);
          dictionary[extendedWord] = dictionary.length;
          word = char;
        }
      },
      handleDone: (sink) {
        if (word.isNotEmpty) sink.add(dictionary[word]!);
      },
    );
  }

  @override
  List<int> convert(String input) {
    final result = <int>[];
    StreamController<String>(sync: true)
      ..stream.transform(encodeTransformer()).listen(result.add)
      ..add(input)
      ..close();
    return result;
  }
}

class LzwDecoder extends Converter<List<int>, String> {
  const LzwDecoder();

  static StreamTransformer<int, String> decodeTransformer() =>
      StreamTransformer.fromBind((stream) {
        final codeUnits = stream
            .transform(decodeUtf8CharTransformer())
            .map((word) => word.codeUnits);
        return utf8.decoder.bind(codeUnits);
      });

  static StreamTransformer<int, String> decodeUtf8CharTransformer() {
    final dictionary = List.of(LzwCodec._initialDictionary.keys);
    var previousWord = '';
    return StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        if (previousWord.isEmpty) {
          sink.add(previousWord = String.fromCharCode(data));
        } else if (data > dictionary.length) {
          sink.addError(ArgumentError.value(data));
        } else {
          final word = data < dictionary.length
              ? dictionary[data]
              : previousWord + previousWord[0];
          sink.add(word);
          dictionary.add(previousWord + word[0]);
          previousWord = word;
        }
      },
    );
  }

  @override
  String convert(List<int> input) {
    final buffer = StringBuffer();
    StreamController<int>(sync: true)
      ..stream.transform(decodeTransformer()).listen(buffer.write)
      ..addAll(input)
      ..close();
    return buffer.toString();
  }
}
