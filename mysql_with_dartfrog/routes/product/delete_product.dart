import 'package:dart_frog/dart_frog.dart';
import 'package:mysql_with_dartfrog/database/mysql_client.dart';

Future<Response> onRequest(RequestContext context) async {
  var request = context.request;

  final headers = request.headers;

  final param = request.uri.queryParameters;

  final id = param['id'];

  final dataRepository = context.read<DataSource>();

  dataRepository.deleteProduct(id);

  return Response.json(body: {'request_body': ""});
}
