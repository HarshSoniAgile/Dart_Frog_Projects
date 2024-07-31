import 'package:dart_frog/dart_frog.dart';
import 'package:my_first_project/model/user_model.dart';
import 'package:mysql_client/mysql_client.dart';

/// creating a database connection with MySQL
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
      databaseName: "test", // option
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

class DataSource {
  /// initializing
  const DataSource(
    this.sqlClient,
  );

  // Fetches all table fields from users table in our database
  Future<List<DatabaseModel>> fetchFields() async {
    // sqlQuey
    const sqlQuery = 'SELECT email, password FROM users;';
    // executing our sqlQuery
    final result = await sqlClient.execute(sqlQuery);
    // a list to save our users from the table -
    // i mean whatever as many as user we get from table

    final users = <DatabaseModel>[];
    for (final row in result.rows) {
      users.add(DatabaseModel.fromRowAssoc(row.assoc()));
    }
    // simply returning the whatever the the users
    // we will get from the MySQL database
    return users;
  }

  // accessing the client
  final MySQLClient sqlClient;
}

/// Middleware ar use for the dependency injection
Handler middleware(Handler handler) {
  // we will call use the handler to handle our request and than
  // we will request a logger which means for each request
  // we will inject our  dependency
  return handler.use(requestLogger()).use(injectionHandler());
}

/// it will get the connection from our sqlClient and based on that
/// it will read the  context of our data source
/// because handler will handle the  each and every request we will make
Middleware injectionHandler() {
  return (handler) {
    return handler.use(
      provider<DataSource>(
        (context) => DataSource(context.read<MySQLClient>()),
      ),
    );
  };
}
