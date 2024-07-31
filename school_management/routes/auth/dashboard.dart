// ignore_for_file: always_declare_return_types, inference_failure_on_function_return_type, unused_local_variable

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
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

_onGet(RequestContext context) async {
  final request = context.request;

  final queryParam = await request.uri.queryParameters;

  final id = int.tryParse(queryParam['id'].toString());

  final dataRepository = context.read<DataSource>();

  final rr = await dataRepository.dashboardCounts();

  if (rr != null) {
    return Response.json(body: ResponseModel(status: HttpStatus.ok, message: StringConst.msgSuccess, data: rr).toJson());
  } else {
    return Response(statusCode: HttpStatus.badRequest, body: rr.toString());
  }
}
