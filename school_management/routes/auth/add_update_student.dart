// ignore_for_file: always_declare_return_types, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:school_management/common/string_const.dart';
import 'package:school_management/common/upload_photo.dart';
import 'package:school_management/database/data_source.dart';
import 'package:school_management/model/response_model.dart';
import 'package:school_management/model/student_model.dart';
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

  final id = int.tryParse(decodeToken(headers['authorization'].toString().replaceFirst("Bearer ", "")).toString());

  StudentModel? studentModel = StudentModel.fromJson(fromData.fields);

  /// assign school id
  studentModel.schoolID = id;

  if (fromData.files['photo'] != null) {
    String? photo = await UploadPhoto.uploadPhoto(photo: fromData.files['photo']);
    studentModel.photo = photo;
  }

  Tuple2<bool, String> validate = isValidFormAddProduct(studentModel);

  if (validate.item1 == false) {
    return Response(statusCode: HttpStatus.badRequest, body: validate.item2);
  }

  final dataRepository = context.read<DataSource>();
  // // based on that we will await and fetch the fields from our database
  studentModel = await dataRepository.addStudent(studentModel);

  if (studentModel != null) {
    return Response.json(
        statusCode: studentModel.id != null ? HttpStatus.ok : HttpStatus.created,
        body: ResponseModel(
                status: HttpStatus.created,
                message: studentModel.id != null ? StringConst.msgUpdateStudent : StringConst.msgAddStudent,
                data: studentModel.toJson())
            .toJson());
  } else {
    return Response(statusCode: HttpStatus.badRequest, body: studentModel.toString());
  }
}

Tuple2<bool, String> isValidFormAddProduct(StudentModel studentModel) {
  final arrList = <Tuple2<ValidationType, String>>[];
  arrList.add(Tuple2(ValidationType.name, studentModel.name ?? ''));
  arrList.add(Tuple2(ValidationType.parentNumber, studentModel.parentNumber ?? ''));
  arrList.add(Tuple2(ValidationType.address, studentModel.address ?? ''));
  arrList.add(Tuple2(ValidationType.photo, studentModel.photo ?? ''));
  arrList.add(Tuple2(ValidationType.dob, studentModel.dob ?? ''));
  arrList.add(Tuple2(ValidationType.std, studentModel.std == null ? '' : studentModel.std.toString()));

  final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

  print(validationResult.item2);

  return Tuple2(validationResult.item1, validationResult.item2);
}
