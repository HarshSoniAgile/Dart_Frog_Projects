import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:mysql_with_dartfrog/database/mysql_client.dart';
import 'package:mysql_with_dartfrog/model/user_model.dart';

Future<Response> onRequest(RequestContext context) async {
// handling the request for our database by reading it's context

  final request = context.request;

  final headers = request.headers;

  print("************************");
  print(request.headers['token']);
  print("************************");

  if (headers['token'] == null) {
    return Response.json(body: "unauthorised user");
  }
  var body = await request.body();

  print(body);

  final dataRepository = context.read<DataSource>();
  // // based on that we will await and fetch the fields from our database
  var rr = await dataRepository.addUser(UserModel.fromJson(jsonDecode(body.toString())));
  print("********$rr");
  // // than we will return the response as JSONs
  return Response.json(body: {'request_body': body});
}
