import 'package:dsalg/dsalg.dart';

class IntComparator extends MemoizedComparator<int> {
  IntComparator() : super((a, b) => a - b);
}
