import 'package:mysql_client/mysql_client.dart';

// class MySQLClient {
//   factory MySQLClient() {
//     return _inst;
//   }
//
//   MySQLClient._internal() {
//     _connect();
//   }
//
//   static final MySQLClient _inst = MySQLClient._internal();
//
//   MySQLConnection? _connection;
//
//   Future<void> _connect() async {
//     _connection = await MySQLConnection.createConnection(
//       host: '127.0.0.1',
//       port: 3306,
//       userName: 'root',
//       password: '12345678',
//       databaseName: 'school_management',
//     );
//
//     await _connection?.connect();
//   }
//
//   Future<IResultSet> execute(
//     String query, {
//     Map<String, dynamic>? params,
//     bool iterable = false,
//   }) async {
//     if (_connection == null || _connection?.connected == false) {
//       await _connect();
//     }
//
//     if (_connection?.connected == false) {
//       throw Exception('Could not connect to the database');
//     }
//     return _connection!.execute(query, params, iterable);
//   }
// }

class MySQLClient {
  /// Returns a singleton
  factory MySQLClient() {
    return _inst;
  }

  MySQLClient._internal() {
    _connect();
  }

  static final MySQLClient _inst = MySQLClient._internal();

  MySQLConnection? _connection;

  // initializes a connection to database
  Future<void> _connect() async {
    _connection = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "12345678",
      databaseName: "school_management", // option
    );
    await _connection?.connect();

    print("connexted");
  }

  // execute a given query and checks for db connection
  Future<IResultSet> execute(
    String query, {
    Map<String, dynamic>? params,
    bool iterable = false,
  }) async {
    if (_connection == null || _connection?.connected == false) {
      await _connect();
    }

    if (_connection?.connected == false) {
      throw Exception('Could not connect to the database');
    }
    return _connection!.execute(query, params, iterable);
  }
}
