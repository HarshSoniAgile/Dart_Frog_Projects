// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:school_management_app/app_logger.dart';
import 'package:school_management_app/network_manager/init_dio.dart';
import 'package:school_management_app/network_manager/response_model.dart';
import 'package:school_management_app/showloader_component.dart';

import 'api_constant.dart';
import 'network_util.dart';

var sharedServiceManager = RemoteServices.singleton;

class RemoteServices {
  static var dio = initDio();

  RemoteServices._internal();

  static final RemoteServices singleton = RemoteServices._internal();

  factory RemoteServices() {
    return singleton;
  }

  /// GET requests
  Future<ResponseModel<T>> createGetRequest<T>(
      {required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam, isLoading = true, isOrangeBG = false}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      isLoading == true ? showLoader() : null;
      final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);

      try {
        Response response = await dio.get(requestFinal.item1, options: Options(headers: requestFinal.item2));
        Logger().v(response);
        final Map<String, dynamic> responseJson = json.decode(jsonEncode(response.data));
        isLoading == true ? dismissLoader() : null;

        return ResponseModel<T>.fromJson(responseJson, response.statusCode!);
      } on DioError catch (e) {
        isLoading == true ? dismissLoader() : null;
        Logger().v(e.response);
        if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
          return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
        } else if (e.type == DioErrorType.connectionTimeout) {
          return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
        } else {
          return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: "SOMETHING WENT WRONG");
        }
      }
    } else {
      return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: "NO INTERNET");
    }
  }

  /// POST requests
  Future<ResponseModel<T>> createPostRequest<T>(
      {required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam, isLoading = true, isOrangeBG = false}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      isLoading == true ? showLoader() : null;
      final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);
      /*
      * item1 => API End-Point
      * item2 => Header
      * item3 => Request Param
      * item4 => Multipart file
      * */
      try {
        Response response = await dio.post(requestFinal.item1, data: requestFinal.item3, options: Options(headers: requestFinal.item2));
        Logger().v(response);
        isLoading == true ? dismissLoader() : null;
        return ResponseModel<T>.fromJson(response.data, response.statusCode);
      } on DioError catch (e) {
        Logger().v(e.response);
        isLoading == true ? dismissLoader() : null;
        if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
          return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
        } else if (e.type == DioErrorType.connectionTimeout) {
          return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
        } else {
          return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: "SOMETHING WENT WRONG");
        }
      }
    } else {
      return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: "NO INTERNET");
    }
  }

  /// PUT requests
  // Future<ResponseModel<T>> createPutRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
  //   if (await NetworkUtil.isNetworkConnected()) {
  //     final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);
  //     /*
  //     * item1 => API End-Point
  //     * item2 => Header
  //     * item3 => Request Param
  //     * item4 => Multipart file
  //     * */
  //     try {
  //       Response response = await dio.put(requestFinal.item1, data: requestFinal.item3, options: Options(headers: requestFinal.item2));
  //
  //       return ResponseModel<T>.fromJson(json.decode(response.data.toString()), response.statusCode);
  //     } on DioError catch (e) {
  //       Logger().v(e.response);
  //       // isLoading == true ? await Future.delayed(const Duration(milliseconds: 500), () => dismissLoader()) : null;
  //       if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
  //         return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
  //       } else if (e.type == DioErrorType.connectionTimeout) {
  //         return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
  //       } else {
  //         return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: "SOMETHING WENT WRONG");
  //       }
  //     }
  //   } else {
  //     return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: "NO INTERNET");
  //   }
  // }

  /// DELETE requests
  // Future<ResponseModel<T>> createDeleteRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
  //   if (await NetworkUtil.isNetworkConnected()) {
  //     showLoader();
  //     final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);
  //     /*
  //     * item1 => API End-Point
  //     * item2 => Header
  //     * item3 => Request Param
  //     * item4 => Multipart file
  //     * */
  //     try {
  //       Response response = await dio.delete(requestFinal.item1, data: requestFinal.item3, options: Options(headers: requestFinal.item2));
  //       dismissLoader();
  //       return ResponseModel<T>.fromJson(response.data, response.statusCode);
  //     } on DioError catch (e) {
  //       dismissLoader();
  //       Logger().v(e.response);
  //       if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
  //         return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
  //       } else if (e.type == DioErrorType.connectionTimeout) {
  //         return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
  //       } else {
  //         return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: "");
  //       }
  //     }
  //   } else {
  //     return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: "");
  //   }
  // }

  ResponseModel<T> createErrorResponse<T>({required int status, required String message}) {
    if (status == 401) {}
    return ResponseModel(status: status, message: message, data: null);
  }

  //
  Future<ResponseModel<T>> uploadRequest<T>(ApiType apiType,
      {Map<String, dynamic>? params, List<AppMultiPartFile>? arrFile, isLoading = true, String? urlParam, bool isOrangeBG = false}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      isLoading == true ? showLoader() : null;
      final requestFinal = ApiConstant.requestParamsForSync(apiType, params: params, arrFile: arrFile ?? []);

      Map<String, dynamic> other = <String, dynamic>{};
      other.addAll(requestFinal.item3);

      /* Adding File Content */
      for (AppMultiPartFile partFile in requestFinal.item4) {
        List<MultipartFile> uploadFiles = [];
        for (File file in partFile.localFiles ?? []) {
          String filename = basename(file.path);

          MultipartFile mFile =
              await MultipartFile.fromFile(file.path, filename: filename, contentType: MediaType('image', filename.split(".").last));
          uploadFiles.add(mFile);
        }
        if (uploadFiles.isNotEmpty) {
          other[partFile.key ?? ""] = (uploadFiles.length == 1) ? uploadFiles.first : uploadFiles;
        }
      }

      FormData formData = FormData.fromMap(other);
      final option = Options(headers: requestFinal.item2);

      try {
        final response = await dio.post(
          requestFinal.item1,
          data: formData,
          options: option,
          onSendProgress: (sent, total) {
            var progress = sent / total;
            Logger().v("uploadFile $progress");
          },
        );
        Logger().i(response);

        isLoading == true ? dismissLoader() : null;
        return ResponseModel<T>.fromJson(json.decode(jsonEncode(response.data)), response.statusCode);
      } on DioError catch (e) {
        isLoading == true ? dismissLoader() : null;
        Logger().v(e.response);
        if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
          return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
        } else if (e.type == DioErrorType.connectionTimeout) {
          return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
        } else {
          return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: "SOMETHING WENT WRONG");
        }
      }
    } else {
      return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: "NO INTERNET");
    }
  }
}
