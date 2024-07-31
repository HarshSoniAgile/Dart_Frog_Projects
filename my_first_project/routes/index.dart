import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first_project/database/mysql_client.dart';

final mysqlClient = MySQLClient();

/*

Handler:-    handle the request
IP:-         default as 127.0.0.1 OR localhost
PORT:-       default 8080

 */

Middleware databaseHandler() {
  return (handler) {
    return handler.use(
      provider<MySQLClient>(
        (context) => mysqlClient,
      ),
    );
  };
}

// function to run our HTTP server
Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(handler.use(databaseHandler()), ip, port);
}

Future<Response> onRequest(RequestContext context) async {
// handling the request for our database by reading it's context

  final dataRepository = context.read<DataSource>();
  // based on that we will await and fetch the fields from our database
  final users = await dataRepository.fetchFields();
  // than we will return the response as JSON
  return Response.json(body: users);
}
