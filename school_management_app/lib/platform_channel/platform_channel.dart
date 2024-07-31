import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:school_management_app/app_logger.dart';

class PlatformChannel {
  final MethodChannel _platform = const MethodChannel("com.goatgrub.app");

  static const platformChannel = MethodChannel('methodChannelForRedeemPromoCode/iOS');

  Future<void> getDeviceModel() async {
    String model;
    try {
      final String result = await platformChannel.invokeMethod('getDeviceModel');

      model = result;
    } catch (e) {
      model = "Can't fetch the method: '$e'.";
    }

    Logger().w("************::: $model");
  }

  Future<bool> checkForPermission(Permission permission) async {
    if (Platform.isIOS) {
      bool result = await _checkContactPermissionForIOS(permission);
      return result;
    } else if (Platform.isAndroid) {
      bool result = await _checkContactPermissionForAndroid(permission);
      return result;
    } else {
      return false;
    }
  }

  Future<bool> _checkContactPermissionForIOS(Permission permission) async {
    PermissionStatus permissionStatus = await permission.status;
    Logger().v(" PermissionStatus :: ${permissionStatus.toString()}");
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == PermissionStatus.denied) {
      Logger().v("PermissionGroup :: $permission");
      PermissionStatus status = await permission.request();
      return status == PermissionStatus.granted;
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      Logger().v("PermissionGroup :: $permission");
      openSettings();
      return false;
    } else {
      return false;
    }
  }

  Future<bool> _checkContactPermissionForAndroid(Permission permission) async {
    PermissionStatus permissionStatus = await permission.status;
    Logger().v(" PermissionStatus :: ${permissionStatus.toString()}");
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == PermissionStatus.denied) {
      PermissionStatus pStatus = await permission.request();
      Logger().v(" PermissionStatus :: ${pStatus.toString()}");
      if (pStatus == PermissionStatus.granted) {
        return true;
      } else if (pStatus == PermissionStatus.permanentlyDenied) {
        return false;
      } else if (pStatus == PermissionStatus.denied) {
        return false;
      } else {
        bool status = await _checkContactPermissionForNeverAsk(permission);
        return status;
      }
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return false;
    }
    return false;
  }

  Future<bool> _checkContactPermissionForNeverAsk(Permission permission) async {
    Logger().v("_check Persmission For NeverAsk");
    PermissionStatus permissionStatus = await permission.request();
    Logger().v(" PermissionStatus :: ${permissionStatus.toString()}");
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return false;
    } else if (permissionStatus == PermissionStatus.denied) {
      return false;
    } else {
      bool status = await _checkContactPermissionForNeverAsk(permission);
      return status;
    }
  }

  Future<bool> openSettings() async {
    bool isOpened = await openAppSettings();
    return isOpened;
  }

  //   //region open Google maps ios
  Future<dynamic> openGoogleMaps({String? sourceLat, String? sourceLong, String? destLat, String? destLong}) async {
    try {
      final result =
          await _platform.invokeMethod('google_map', {"sourceLat": sourceLat, "sourceLong": sourceLong, "destLat": destLat, "destLong": destLong});
      return result;
    } on PlatformException catch (e) {
      Logger().e("Exception :: ${e.message}");
      return 568.0;
    }
  }

  //   //region open Google maps ios
  Future<dynamic> openLocationService() async {
    try {
      final result = await _platform.invokeMethod('openLocationServices');
      return result;
    } on PlatformException catch (e) {
      Logger().e("Exception :: ${e.message}");
      return 568.0;
    }
  }

//endregion

  Future<dynamic> openAppleMaps({String? sourceLat, String? sourceLong, String? destLat, String? destLong}) async {
    try {
      final result =
          await _platform.invokeMethod('apple_map', {"sourceLat": sourceLat, "sourceLong": sourceLong, "destLat": destLat, "destLong": destLong});
      return result;
    } on PlatformException catch (e) {
      Logger().e("Exception :: ${e.message}");
      return 568.0;
    }
  }
}
