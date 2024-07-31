import 'dart:io';

import 'package:school_management_app/main.dart';
import 'package:tuple/tuple.dart';

import '../app_logger.dart';

enum Environment { local, staging, dev, prod }

enum ApiType {
  addUser,
  getProductList,
  getProduct,
  deleteProduct,
  addProduct,
  editProduct,
}

class ApiConstant {
  static const int statusCodeSuccess = 200;
  static const int statusCodeCreated = 201;
  static const int statusCodeNotFound = 404;
  static const int statusCodeServiceNotAvailable = 503;
  static const int statusCodeBadGateway = 502;
  static const int statusCodeServerError = 500;
  static const int statusCodeUnauthorized = 401;

  static const int timeoutDurationNormalAPIs = 30000;

  /// 30 seconds
  static const int timeoutDurationMultipartAPIs = 120000;

  /// 120 seconds

  ///default Location
  static String mapStyle = "assets/map_style.txt";
  static double staticLatitude = 35.946555;
  static double staticLongitude = -111.2388952;

  static const String appleAppSecret = '6270d76935434d8fafcbd794ccabbac7';

  static String get baseDomain {
    switch (env) {
      case Environment.local:
        return 'http://192.168.3.243:8080';
      case Environment.staging:
        return 'https://stage-apigoatgrub.admindd.com';
      case Environment.dev:
        return 'https://node-goat-grub-backend.agiletechnologies.in';
      case Environment.prod:
        return 'https://api.mygoatgrub.com/';
      default:
        return "";
    }
  }

  static String get getClaimSite {
    switch (env) {
      case Environment.local:
        return 'http://192.168.3.43:3000';
      case Environment.staging:
        return 'https://stage-goatgrub.admindd.com/claim/';
      case Environment.dev:
        return 'https://react-goat-grub-website.agiletechnologies.in/claim/';
      case Environment.prod:
        return 'https://api.mygoatgrub.com/login';
      default:
        return "";
    }
  }

  static String get userAuthRestaurant {
    return "/users/auth/restaurant/";
  }

  static String get userAuthNotifications {
    return "/users/auth/notifications/";
  }

  static String get userAuth {
    return "/users/auth/";
  }

  static String getValue(ApiType type) {
    Logger().i(baseDomain);
    switch (type) {
      case ApiType.addUser:
        return '/add_user';
      case ApiType.getProductList:
        return '/product/get_product_list';
      case ApiType.addProduct:
        return '/product/add_product';
      case ApiType.getProduct:
        return '/product/get_product';
      case ApiType.editProduct:
        return '/product/edit_product';
      case ApiType.deleteProduct:
        return '/product/delete_product';

      default:
        return "";
    }
  }

  /*
  * Tuple Sequence
  * - Url
  * - Header
  * - params
  * - files
  * */
  static Tuple4<String, Map<String, String>, Map<String, dynamic>, List<AppMultiPartFile>> requestParamsForSync(
    ApiType type, {
    Map<String, dynamic>? params,
    List<AppMultiPartFile> arrFile = const [],
    String? urlParams,
  }) {
    String apiUrl = ApiConstant.baseDomain + ApiConstant.getValue(type);

    if (urlParams != null) apiUrl = apiUrl + urlParams;

    Map<String, dynamic> paramsFinal = params ?? <String, dynamic>{};
    Map<String, String> headers = <String, String>{};

    // if (type == ApiType.login || type == ApiType.signup) {
    //   paramsFinal['deviceType'] = DeviceUtil().deviceType;
    //   paramsFinal['deviceId'] = DeviceUtil().deviceId;
    //   paramsFinal['deviceToken'] = FireBaseCloudMessagingWrapper().fcmToken;
    //
    //   // headers['Content-Type'] = 'application/json';
    // }
    //
    // if (userSingleton.accessToken != null && userSingleton.accessToken != '' && type != ApiType.login) {
    //   headers['Authorization'] = userSingleton.accessToken!;
    // }

    Logger().d("Request Url :: $apiUrl");
    Logger().d("Request Params :: $paramsFinal");
    Logger().d("Request headers :: $headers");

    return Tuple4(apiUrl, headers, paramsFinal, arrFile);
  }
}

class AppMultiPartFile {
  List<File>? localFiles;
  String? key;

  AppMultiPartFile({this.localFiles, this.key});

  AppMultiPartFile.fromType({this.localFiles, this.key});
}
