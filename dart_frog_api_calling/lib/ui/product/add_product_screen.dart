import 'package:dart_frog_api_calling/model/product_model.dart';
import 'package:dart_frog_api_calling/ui/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController productController = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    getData();
    productController.productPhoto.value = null;
    super.initState();
  }

  getData() async {
    if (widget.id != null) {
      bool res = await productController.getProductAPICall(id: widget.id);
      if (res == true) {
        nameController.text = productController.productData.value?.name ?? "";
        originController.text = productController.productData.value?.origin ?? "";
        descriptionController.text = productController.productData.value?.description ?? "";
        priceController.text = productController.productData.value?.price ?? "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    productController.selectProfileImage();
                  },
                  child: widget.id != null && productController.productData.value?.photos != null && productController.productPhoto.value == null
                      ? Image.network(
                          productController.productData.value!.photos!,
                          fit: BoxFit.cover,
                        )
                      : Obx(() => productController.productPhoto.value == null
                          ? Container(
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                ),
                              ),
                            )
                          : Container(
                              child: Image.file(
                              productController.productPhoto.value!,
                              fit: BoxFit.cover,
                            ))),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Product Name",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Product Description",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: originController,
              decoration: const InputDecoration(
                hintText: "Product Origin",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                hintText: "Product Price",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                var productModel = ProductModel(
                    id: widget.id,
                    name: nameController.text,
                    description: descriptionController.text,
                    origin: originController.text,
                    price: priceController.text);

                if (widget.id != null) {
                  productController.editProductAPICall(productModel: productModel);
                } else {
                  await productController.addProductAPICall(
                    productModel: productModel,
                  );
                }
              },
              child: Text(widget.id != null ? "Save" : "Add"),
            ),
          ],
        ),
      )),
    );
  }
}
