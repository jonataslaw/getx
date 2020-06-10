import 'package:benckmark/item.dart';
import 'package:get/get.dart';

class Controller extends GetController {
  @override
  onInit() async {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      addItem(Item(title: DateTime.now().toString()));
    }
    print("It's done. Print now!");
    super.onInit();
  }

  final items = List<Item>.of(sampleItems);

  void addItem(Item item) {
    items.add(item);
    update();
  }
}
