import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<ProductDetailsController>(
      () => ProductDetailsController(
        Get.parameters['productId'] ?? '',
      ),
    );
  }
}
