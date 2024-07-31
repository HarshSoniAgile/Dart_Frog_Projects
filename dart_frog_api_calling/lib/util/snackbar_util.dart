import 'package:flutter/material.dart';

enum SnackType { success, error, warning, info, orangeBackgroundError }

class SnackBarUtil {
  static void showSnackBar({
    required BuildContext context,
    required SnackType type,
    required String message,
  }) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: getBackgroundColorByType(snackType: type),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color getBackgroundColorByType({required SnackType snackType}) {
    if (snackType == SnackType.success) {
      return Colors.green;
    } else if (snackType == SnackType.warning) {
      return Colors.yellow.shade200;
    } else if (snackType == SnackType.error) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }
}
