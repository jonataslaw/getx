import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.loadDemoProductsFromSomeWhere,
        label: Text('Add'),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            controller.products.clear();
            controller.loadDemoProductsFromSomeWhere();
          },
          child: ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final item = controller.products[index];
              return ListTile(
                onTap: () {
                  Get.getDelegate()?.toNamed(Routes.PRODUCT_DETAILS(item.id));
                },
                title: Text(item.name),
                subtitle: Text(item.id),
              );
            },
          ),
        ),
      ),
    );
  }
}
