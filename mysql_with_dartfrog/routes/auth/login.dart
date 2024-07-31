import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mysql_with_dartfrog/database/mysql_client.dart';
import 'package:mysql_with_dartfrog/model/user_model.dart';

onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed, body: "method not allowed"),
      )
  };
}

_onPost(RequestContext context) async {
  final body = await context.request.formData();

  final username = body.fields['username'];
  final password = body.fields['password'];

  if (username == null || password == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final authenticator = context.read<DataSource>();

  final user = await authenticator.getUser(username: username, password: password);

  if (user == null) {
    return Response(statusCode: HttpStatus.unauthorized, body: "unauthorized user");
  } else {
    return Response.json(body: {'token': generateToken(user: user), 'data': verifyToken(generateToken(user: user))});
  }
}

String generateToken({
  required UserModel user,
}) {
  final jwt = JWT(
    {
      'id': user.id,
      'name': user.firstName,
      'email': user.email,
    },
  );

  return jwt.sign(SecretKey('123'));
}

verifyToken(token) {
  final jwt = JWT.decode(token);
  print(jwt.payload);
  return jwt.payload;
}
