// ignore_for_file: cascade_invocations, lines_longer_than_80_chars

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:school_management/common/password_generate.dart';
import 'package:school_management/common/send_mail.dart';
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

_onPost(RequestContext context) async {
  final request = context.request;

  final fromData = await request.formData();

  SchoolModel? schoolModel = SchoolModel.fromJson(fromData.fields);

  if (fromData.files['photo'] != null) {
    String? photo = await UploadPhoto.uploadPhoto(photo: fromData.files['photo']);
    schoolModel.photo = photo;
  }

  final validate = isValidFormAddProduct(schoolModel);

  if (validate.item1 == false) {
    return Response(statusCode: HttpStatus.badRequest, body: validate.item2);
  }
  final dataRepository = context.read<DataSource>();

  /// check email already exist or not
  if (await dataRepository.checkEmail(schoolModel.email ?? "")) {
    return Response(statusCode: HttpStatus.badRequest, body: StringConst.msgEmailAlreadyExist);
  }

  String? genratePassword = PasswordGenrate().getRandomString(8);

  var res = await SendMail.sendMail(mail: schoolModel.email, generatedPassword: genratePassword);

  if (res) {
    schoolModel.password = PasswordGenrate().encryptPassword(genratePassword);
    PasswordGenrate().decryptPassword(schoolModel.password ?? "");

    schoolModel = await dataRepository.addSchool(schoolModel);

    schoolModel?.token = generateToken(schoolModel: schoolModel);

    if (schoolModel != null) {
      return Response.json(
          statusCode: HttpStatus.created,
          body: ResponseModel(status: HttpStatus.created, message: StringConst.msgAddSchool, data: schoolModel.toJson()).toJson());
    } else {
      return Response(statusCode: HttpStatus.badRequest, body: schoolModel.toString());
    }
  } else {
    return Response(statusCode: HttpStatus.badRequest, body: StringConst.msgMailNotSent);
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
