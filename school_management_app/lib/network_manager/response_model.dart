import 'package:school_management_app/model/product_model.dart';

class ResponseModel<T> {
  ResponseModel({this.status, this.message, this.data});

  late int? status;
  late String? message;
  T? data;

  ResponseModel.fromJson(Map<String, dynamic> json, int? statusCode) {
    status = json['status'];
    message = json['message'];
    data = (json['data'] == null || json["data"].length == 0)
        ? null
        : _handleClasses(
            json['data'],
          );
  }

  _handleClasses(json) {
    if (T == List<ProductModel>) {
      List<ProductModel> aryOfOnboardings = [];
      if (json != null && json is List<dynamic>) {
        for (var element in json) {
          aryOfOnboardings.add(ProductModel.fromJson(element as Map<String, dynamic>));
        }
      }
      return aryOfOnboardings as T;
    } else if (T == ProductModel) {
      return ProductModel.fromJson(json) as T;
    } else {
      return json;
    }
  }
}
