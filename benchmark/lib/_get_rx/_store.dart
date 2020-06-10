import 'package:benckmark/item.dart';
import 'package:get/get.dart';

class Controller extends RxController {
  final items = sampleItems.obs;

  @override
  onInit() async {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      addItem(Item(title: DateTime.now().toString()));
    }

    print("It's done. Print now!");
    super.onInit();
  }

  void addItem(Item item) {
    items.add(item);
  }
}
