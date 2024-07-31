import 'package:dart_frog/dart_frog.dart';
import 'package:mysql_with_dartfrog/database/mysql_client.dart';

Future<Response> onRequest(RequestContext context) async {
// handling the request for our database by reading it's context

  final request = context.request;

  final headers = request.headers;

  final param = request.uri.queryParameters;

  final password = param['password'] ?? "";

  final dataRepository = context.read<DataSource>();
  // based on that we will await and fetch the fields from our database
  final users = await dataRepository.fetchFields(password: password);
  // than we will return the response as JSON
  return Response.json(body: users);
}
