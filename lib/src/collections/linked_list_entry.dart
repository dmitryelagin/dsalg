class LinkedListEntry<T> {
  LinkedListEntry(this.value, [this.next]);

  final T value;

  LinkedListEntry<T>? next;

  void unlinkNext() {
    next = null;
  }
}
