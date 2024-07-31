import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:school_management/common/string_const.dart';
import 'package:school_management/database/data_source.dart';
import 'package:school_management/model/response_model.dart';

onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed, body: StringConst.methodNotAllowed),
      )
  };
}

decodeToken(token) {
  final jwt = JWT.decode(token.toString());

  return jwt.payload['id'];
}

_onGet(RequestContext context) async {
  final request = context.request;

  final headers = request.headers;

  final queryParam = await request.uri.queryParameters;

  final page = int.tryParse(queryParam['page'].toString());
  final limit = int.tryParse(queryParam['limit'].toString());

  final schoolId = int.tryParse(decodeToken(headers['authorization'].toString().replaceFirst("Bearer ", "")).toString());

  final dataRepository = context.read<DataSource>();

  final rr = await dataRepository.getAllStudent(page, limit, schoolId);

  if (rr != null) {
    return Response.json(body: ResponseModel(status: HttpStatus.ok, message: StringConst.msgSuccess, data: rr).toJson());
  } else {
    return Response(statusCode: HttpStatus.badRequest, body: rr.toString());
  }
}
