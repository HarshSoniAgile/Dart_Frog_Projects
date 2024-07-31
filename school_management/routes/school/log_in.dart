// ignore_for_file: lines_longer_than_80_chars, cascade_invocations

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:school_management/common/app_logger.dart';
import 'package:school_management/common/password_generate.dart';
import 'package:school_management/database/data_source.dart';
import 'package:school_management/model/response_model.dart';
import 'package:school_management/model/school_model.dart';
import 'package:school_management/validation/validation.dart';
import 'package:tuple/tuple.dart';

onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed, body: 'method not allowed'),
      )
  };
}

_onPost(RequestContext context) async {
  final request = context.request;

  final fromData = await request.formData();

  String? email = fromData.fields['email'];
  String? password = fromData.fields['password'];

  Tuple2<bool, String> validate = isValidFormAddProduct(email, password);

  if (validate.item1 == false) {
    return Response(statusCode: HttpStatus.badRequest, body: validate.item2);
  }

  final dataRepository = context.read<DataSource>();
  // password = PasswordGenrate().encryptPassword(password ?? "");

  SchoolModel? schoolModel = await dataRepository.logIn(email);
  schoolModel?.token = generateToken(schoolModel: schoolModel);

  Logger().i(PasswordGenrate().decryptPassword(schoolModel?.password ?? ""));

  if (password == PasswordGenrate().decryptPassword(schoolModel?.password ?? "")) {
    return Response.json(
        statusCode: HttpStatus.ok, body: ResponseModel(status: HttpStatus.ok, message: 'LogIn successfully', data: schoolModel?.toJson()).toJson());
  } else {
    return Response(statusCode: HttpStatus.badRequest, body: 'Please check email or password');
  }
}

String generateToken({
  required SchoolModel? schoolModel,
}) {
  final jwt = JWT(
    {
      'id': schoolModel?.id,
      'name': schoolModel?.name,
      'email': schoolModel?.email,
    },
  );

  return jwt.sign(SecretKey('123'));
}

Tuple2<bool, String> isValidFormAddProduct(String? email, String? password) {
  final arrList = <Tuple2<ValidationType, String>>[];
  arrList.add(Tuple2(ValidationType.email, email ?? ''));
  arrList.add(Tuple2(ValidationType.password, password ?? ''));

  final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

  return Tuple2(validationResult.item1, validationResult.item2);
}
