import 'package:get/get.dart';

import '../../../../models/demo_product.dart';

class ProductsController extends GetxController {
  final products = <DemoProduct>[].obs;

  void loadDemoProductsFromSomeWhere() {
    products.add(
      DemoProduct(
        name: 'Product added on: ${DateTime.now().toString()}',
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
    loadDemoProductsFromSomeWhere();
  }

  @override
  void onClose() {
    Get.printInfo(info: 'Products: onClose');
    super.onClose();
  }
}
