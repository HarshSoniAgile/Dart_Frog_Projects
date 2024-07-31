// ignore_for_file: cascade_invocations, lines_longer_than_80_chars, always_declare_return_types

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:school_management/common/string_const.dart';
import 'package:school_management/common/upload_photo.dart';
import 'package:school_management/database/data_source.dart';
import 'package:school_management/model/response_model.dart';
import 'package:school_management/model/school_model.dart';
import 'package:school_management/validation/validation.dart';
import 'package:tuple/tuple.dart';

onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed, body: StringConst.methodNotAllowed),
      )
  };
}

decodeToken(token) {
  final jwt = JWT.decode(token.toString());

  return jwt.payload['id'];
}

_onPost(RequestContext context) async {
  final request = context.request;

  final headers = request.headers;

  final fromData = await request.formData();

  final schoolModel = SchoolModel.fromJson(fromData.fields);

  schoolModel.id = int.tryParse(decodeToken(headers['authorization'].toString().replaceFirst("Bearer ", "")).toString());

  if (fromData.files['photo'] != null) {
    String? photo = await UploadPhoto.uploadPhoto(photo: fromData.files['photo']);
    schoolModel.photo = photo;
  }

  Tuple2<bool, String> validate = isValidFormAddProduct(schoolModel);

  if (validate.item1 == false) {
    return Response(statusCode: HttpStatus.badRequest, body: validate.item2);
  }

  final dataRepository = context.read<DataSource>();
  // // based on that we will await and fetch the fields from our database
  var rr = await dataRepository.editSchool(schoolModel);

  if (rr == true) {
    return Response.json(body: ResponseModel(status: HttpStatus.ok, message: StringConst.msgUpdateSchool, data: schoolModel.toJson()).toJson());
  } else {
    return Response(statusCode: HttpStatus.badRequest, body: rr.toString());
  }
}

Tuple2<bool, String> isValidFormAddProduct(SchoolModel schoolModel) {
  final arrList = <Tuple2<ValidationType, String>>[];
  arrList.add(Tuple2(ValidationType.name, schoolModel.name ?? ''));
  arrList.add(Tuple2(ValidationType.email, schoolModel.email ?? ''));
  arrList.add(Tuple2(ValidationType.address, schoolModel.address ?? ''));
  arrList.add(Tuple2(ValidationType.photo, schoolModel.photo ?? ''));
  arrList.add(Tuple2(ValidationType.zipcode, schoolModel.zipcode == null ? '' : schoolModel.zipcode.toString()));
  arrList.add(Tuple2(ValidationType.city, schoolModel.city ?? ''));
  arrList.add(Tuple2(ValidationType.state, schoolModel.state ?? ''));
  arrList.add(Tuple2(ValidationType.contry, schoolModel.contry ?? ''));

  final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

  print(validationResult.item2);

  return Tuple2(validationResult.item1, validationResult.item2);
}
