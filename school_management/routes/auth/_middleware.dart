// ignore_for_file: always_declare_return_types, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:school_management/common/app_logger.dart';
import 'package:school_management/database/data_source.dart';

Handler middleware(Handler handler) {
  return handler.use(
    bearerAuthentication(
      authenticator: (context, token) async {
        return verifyToken(token, context);
      },
    ),
  );
}

verifyToken(token, RequestContext context) async {
  final jwt = JWT.tryDecode(token.toString());

  Logger().e(token);
  final dataRepository = context.read<DataSource>();
  Logger().i(jwt?.payload);

  var rr = await dataRepository.getSchool(jwt?.payload['id']);

  if (rr == null) {
    Response(statusCode: HttpStatus.unauthorized);
  } else {
    return rr;
  }
}
