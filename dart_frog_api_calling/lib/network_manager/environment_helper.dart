import 'package:dart_frog_api_calling/app_logger.dart';

class Environmenthelper {
  Map<String, dynamic> environmentMap = {};
  factory Environmenthelper() {
    return _singleton;
  }
  Environmenthelper._internal() {
    Logger().v("Instance created Environmenthelper");
  }

  static final Environmenthelper _singleton = Environmenthelper._internal();
}
