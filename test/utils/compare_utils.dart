extension ComparatorUtils<T> on Comparator<T> {
  Comparator<T> get reversed => (a, b) => this(a, b) * (-1);
}

int compareInt(int a, int b) => a - b;
