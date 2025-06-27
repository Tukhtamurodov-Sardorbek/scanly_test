extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) condition) {
    if (isEmpty) return null;
    for (final element in this) {
      if (condition(element)) return element;
    }
    return null;
  }
}
