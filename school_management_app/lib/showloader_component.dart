import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_logger.dart';

dismissLoader() {
  Get.back();
}

showLoader({Color loaderColor = Colors.black}) {
  Logger().v("Show Loader");

  PageRouteBuilder builder = PageRouteBuilder(
      opaque: false,
      pageBuilder: (con, _, __) {
        return WillPopScope(
          onWillPop: willPop,
          child: Container(
            color: Colors.black.withOpacity(0.3),
            height: MediaQuery.of(Get.context!).size.height,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
  Navigator.of(Get.context!).push(
    builder,
  );
}

Future<bool> willPop() async {
  return false;
}
