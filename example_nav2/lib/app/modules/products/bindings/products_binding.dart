import 'package:get/get.dart';

import '../controllers/products_controller.dart';

class ProductsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<ProductsController>(
        () => ProductsController(),
      )
    ];
  }
}
