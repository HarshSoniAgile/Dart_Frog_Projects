import 'package:dart_frog_api_calling/ui/product/add_product_screen.dart';
import 'package:dart_frog_api_calling/ui/product/product_binding.dart';
import 'package:dart_frog_api_calling/ui/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductController productController = Get.find();

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  apiCall() async {
    await productController.getAllProductListAPICall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddProductScreen());
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Obx(
            () => RefreshIndicator(
              onRefresh: () async {
                await productController.getAllProductListAPICall(isShowLoader: false);
              },
              child: ListView.builder(
                itemCount: productController.productList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                          AddProductScreen(
                            id: productController.productList[index].id,
                          ),
                          binding: ProductBinding());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: -2,
                        ),
                      ]),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: productController.productList[index].photos != null
                                      ? Image.network(
                                          productController.productList[index].photos!,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productController.productList[index].name ?? ""),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(productController.productList[index].description ?? ""),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(productController.productList[index].origin ?? ""),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: IconButton(
                              onPressed: () async {
                                await productController.deleteProductAPICall(id: productController.productList[index].id);
                              },
                              icon: Icon(Icons.delete_forever),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
