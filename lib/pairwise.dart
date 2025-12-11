class PairwiseIterable<T> extends Iterable<(T, T)> {
  final Iterable<T> iter;

  PairwiseIterable(this.iter);

  @override
  Iterator<(T, T)> get iterator => _Pairwise(iter.iterator);
}

class _Pairwise<T> implements Iterator<(T, T)> {
  final Iterator<T> iter;
  T? prev;

  _Pairwise(this.iter);

  @override
  (T, T) get current => (prev!, iter.current);

  @override
  bool moveNext() {
    if (prev == null) {
      if (!iter.moveNext()) {
        return false;
      }
    }
    prev = iter.current;
    return iter.moveNext();
  }
}

extension IterableTap<E> on Iterable<E> {
  Iterable<E> tap(void Function(E e) forElement) => map((e) {
    forElement(e);
    return e;
  });
}

extension IterableIndexedReduce<T> on Iterable<T> {
  T reduceIndexed(T Function(int index, T previous, T element) combine) {
    var iterator = this.iterator;
    if (!iterator.moveNext()) {
      throw StateError('no elements');
    }
    var index = 0;
    var result = iterator.current;
    while (iterator.moveNext()) {
      result = combine(index++, result, iterator.current);
    }
    return result;
  }
}