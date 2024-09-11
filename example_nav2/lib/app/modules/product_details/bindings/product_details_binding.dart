import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.spawn<ProductDetailsController>(
        () => ProductDetailsController(
          Get.parameters['productId'] ?? '',
        ),
      )
    ];
  }
}
