List<T> setAtIndex<T>(T item, int index, List<T> list) {
  final pre = list.take(index);
  final post = list.skip(index + 1).take(list.length - index - 1);
  return [...pre, item, ...post];
}

List<List<T>> pushToIndex<T>(T item, int index, List<List<T>> list) {
  final pre = list.take(index);
  final post = list.skip(index + 1).take(list.length - index - 1);
  return [
    ...pre,
    [...list[index], item],
    ...post
  ];
}

int? findIndex<T>(bool Function(T) fn, List<T> list) =>
    list.asMap().keys.fold<int?>(null, (found, index) => found ?? (fn(list[index]) ? index : null));
