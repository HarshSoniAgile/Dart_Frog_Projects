import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:school_management/database/mysql_client.dart';

MySQLClient mySQLClient = MySQLClient();

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(handler.use(databaseHandler()), ip, port);
}

Middleware databaseHandler() {
  return (handler) {
    return handler.use(
      provider<MySQLClient>(
        (context) => mySQLClient,
      ),
    );
  };
}
