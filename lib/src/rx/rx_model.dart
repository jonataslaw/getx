class Change<T> {
  /// Value before change
  final T $old;

  /// Value after change
  final T $new;

  final T item;

  final ListChangeOp op;

  final int pos;

  final DateTime time;
  final int batch;
  Change(
      {this.$new,
      this.$old,
      this.batch,
      this.item,
      this.op,
      this.pos,
      DateTime time})
      : time = time ?? DateTime.now();
  String toString() => 'Change(new: ${$new}, old: ${$old})';

  Change.insert(
      {this.$new, this.$old, this.batch, this.item, this.pos, DateTime time})
      : op = ListChangeOp.add,
        time = time ?? new DateTime.now();

  Change.set(
      {this.$new, this.$old, this.batch, this.item, this.pos, DateTime time})
      : op = ListChangeOp.set,
        time = time ?? new DateTime.now();

  Change.remove(
      {this.$new, this.$old, this.batch, this.item, this.pos, DateTime time})
      : op = ListChangeOp.remove,
        time = time ?? new DateTime.now();

  Change.clear({this.$new, this.$old, this.batch, DateTime time})
      : op = ListChangeOp.clear,
        pos = null,
        item = null,
        time = time ?? new DateTime.now();
}

typedef bool Condition();

typedef E ChildrenListComposer<S, E>(S value);

/// Change operation
enum ListChangeOp { add, remove, clear, set }
