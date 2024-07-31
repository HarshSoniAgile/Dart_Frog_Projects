import 'dart:io';

import 'package:dart_frog_api_calling/app_logger.dart';
import 'package:dart_frog_api_calling/media_selector_manager/media_selector.dart';
import 'package:dart_frog_api_calling/model/product_model.dart';
import 'package:dart_frog_api_calling/network_manager/api_constant.dart';
import 'package:dart_frog_api_calling/network_manager/remote_services.dart';
import 'package:dart_frog_api_calling/network_manager/response_model.dart';
import 'package:dart_frog_api_calling/util/snackbar_util.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxList<ProductModel> productList = <ProductModel>[].obs;
  Rxn<File> productPhoto = Rxn();
  Rxn<ProductModel> productData = Rxn();

  /// select profile image from gallery or camera
  selectProfileImage() {
    MediaSelector().chooseImageWithOption(
      purpose: MediaFor.profile,
      callBack: (List<File>? files, int? type) {
        if (files != null) {
          productPhoto.value = files[0];
        }
      },
    );
  }

  getAllProductListAPICall({bool? isShowLoader}) async {
    ResponseModel<List<ProductModel>> response = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.getProductList,
      isLoading: true,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      productList.value = response.data ?? [];
      Logger().i(response.data);
    } else {
      ///***** Api Error *****///
    }
  }

  getProductAPICall({bool? isShowLoader, id}) async {
    String? urlParam = "?id=$id";

    ResponseModel<ProductModel> response = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.getProduct,
      isLoading: true,
      urlParam: urlParam,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      productData.value = response.data;
      Logger().i(response.data);
      return true;
    } else {
      return false;
    }
  }

  deleteProductAPICall({bool? isShowLoader, id}) async {
    String? urlParam = "?id=$id";

    ResponseModel<ProductModel> response = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.deleteProduct,
      isLoading: true,
      urlParam: urlParam,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      return false;
    }
  }

  addProductAPICall({bool? isShowLoader, required ProductModel productModel, onError}) async {
    Map<String, dynamic> param = {
      'name': productModel.name,
      'description': productModel.description,
      'origin': productModel.origin,
      'price': productModel.price,
    };

    var file = productPhoto.value != null ? AppMultiPartFile(localFiles: [productPhoto.value!], key: 'photo') : null;

    ResponseModel<List<ProductModel>> response = await sharedServiceManager.uploadRequest(
      ApiType.addProduct,
      isLoading: true,
      params: param,
      arrFile: productPhoto.value != null ? [file!] : null,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      Logger().i(response.data);
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message ?? "");
      return false;
    }
  }

  editProductAPICall({bool? isShowLoader, required ProductModel productModel}) async {
    Map<String, dynamic> param = {
      'id': productModel.id,
      'name': productModel.name,
      'description': productModel.description,
      'origin': productModel.origin,
      'price': productModel.price,
    };

    var file = productPhoto.value != null ? AppMultiPartFile(localFiles: [productPhoto.value!], key: 'photo') : null;

    ResponseModel<List<ProductModel>> response = await sharedServiceManager.uploadRequest(
      ApiType.editProduct,
      isLoading: true,
      params: param,
      arrFile: file != null ? [file] : null,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      Logger().i(response.data);
    } else {
      ///***** Api Error *****///
    }
  }
}
