// ignore_for_file: always_declare_return_types, inference_failure_on_function_return_type

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:school_management/common/string_const.dart';
import 'package:school_management/database/data_source.dart';

onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.delete => _onDelete(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed, body: StringConst.methodNotAllowed),
      )
  };
}

_onDelete(RequestContext context) async {
  final request = context.request;

  final queryParam = await request.uri.queryParameters;

  final id = int.tryParse(queryParam['id'].toString());

  final dataRepository = context.read<DataSource>();

  final rr = await dataRepository.deleteStudent(id);

  if (rr == true) {
    return Response(statusCode: HttpStatus.badRequest, body: StringConst.msgDeleteStudent);
  } else {
    return Response(statusCode: HttpStatus.badRequest, body: rr.toString());
  }
}
