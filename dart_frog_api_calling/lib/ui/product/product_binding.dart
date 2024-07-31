import 'package:dart_frog_api_calling/ui/product/product_controller.dart';
import 'package:get/get.dart';

class ProductBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => ProductController());
  }

}