import 'package:dsalg/dsalg.dart';
import 'package:test/test.dart';

import 'commons/base_comparator_test.dart';

void main() {
  group('MemoizedComparator', () {
    testBaseComparator(<T>(compare) => MemoizedComparator(compare));
  });
}
