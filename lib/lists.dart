List<T> setAtIndex<T>(List<T> list, T item, int index) {
  final pre = list.take(index);
  final post = list.skip(index + 1).take(list.length - index - 1);
  return [
    ...pre,
    item,
    ...post,
  ];
}

List<List<T>> pushToIndex<T>(List<List<T>> list, T item, int index) {
  final pre = list.take(index);
  final post = list.skip(index + 1).take(list.length - index - 1);
  return [
    ...pre,
    [...list[index], item],
    ...post,
  ];
}

List<List<T>> deleteFromIndex<T>(List<List<T>> list, int index, int count) {
  final pre = list.take(index);
  final post = list.skip(index + 1).take(list.length - index - 1);
  return [
    ...pre,
    list[index].take(count).toList(),
    ...post,
  ];
}

int? findIndex<T>(List<T> list, bool Function(T) fn) =>
    list.asMap().keys.fold<int?>(null, (found, index) => found ?? (fn(list[index]) ? index : null));
