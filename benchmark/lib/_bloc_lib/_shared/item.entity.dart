import 'package:meta/meta.dart';

import 'entitity.dart';

@immutable
class Item extends Entity {
  final String title;

  Item({String id, this.title}) : super();

  @override
  List<Object> get props => super.props..addAll([id, title]);
}

final List<Item> sampleItems = [
  Item(title: 'Item 1'),
  Item(title: 'Item 2'),
  Item(title: 'Item 3')
];
