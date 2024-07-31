import 'package:mysql_client/mysql_client.dart';
import 'package:mysql_with_dartfrog/model/product_model.dart';
import 'package:mysql_with_dartfrog/model/user_model.dart';

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
  Future<List<UserModel>> fetchFields({String? password}) async {
    // sqlQuey
    var sqlQuery =
        password?.isNotEmpty == true ? 'SELECT email, password FROM users where password=$password;' : 'SELECT email, password FROM users;';
    // executing our sqlQuery
    final result = await sqlClient.execute(sqlQuery);
    // a list to save our users from the table -
    // i mean whatever as many as user we get from table

    final users = <UserModel>[];
    for (final row in result.rows) {
      users.add(UserModel.fromRowAssoc(row.assoc()));
    }
    // simply returning the whatever the the users
    // we will get from the MySQL database
    return users;
  }

  Future getUser({String? username, String? password}) async {
    var sqlQuery = 'select * from users where email="$username";';

    final result = await sqlClient.execute(sqlQuery);

    UserModel? user = result.rows.isNotEmpty ? UserModel.fromJson(result.rows.first.assoc()) : null;

    return user;
  }

  Future addUser(UserModel databaseModel) async {
    try {
      var sqlQuery =
          'INSERT INTO users(first_name,last_name,email,password) VALUES ("${databaseModel.firstName}", "${databaseModel.lastName}", "${databaseModel.email}", "${databaseModel.password}");';

      final result = await sqlClient.execute(sqlQuery);

      print("****** res ::::: $result");
    } catch (e) {
      return e;
    }
  }

  Future addProduct(ProductModel productModel) async {
    var sqlQuery =
        'INSERT INTO product(name,description,origin,photo, price) VALUES ("${productModel.name}" , "${productModel.description}" , "${productModel.origin}","${productModel.photos}", ${double.tryParse(productModel.price ?? "0")})';

    final result = await sqlClient.execute(sqlQuery);

    print("****** res ::::: $result");
  }

  Future deleteProduct(id) async {
    var sqlQuery = 'DELETE FROM product WHERE id=$id';

    final result = await sqlClient.execute(sqlQuery);

    print("****** res ::::: $result");
  }

  Future editProduct(ProductModel productModel) async {
    ProductModel temp = await getProduct(id: productModel.id);

    if (temp.id != null) {
      var sqlQuery =
          'UPDATE product SET name = "${productModel.name}" , description = "${productModel.description}" , origin = "${productModel.origin}" , photo = "${productModel.photos ?? temp.photos}", price = ${double.tryParse(productModel.price ?? "0")} WHERE id = ${(productModel.id)}';

      final result = await sqlClient.execute(sqlQuery);

      print("****** res ::::: $result");
    } else {}
  }

  Future<List<ProductModel>> getProductList() async {
    // sqlQuey
    var sqlQuery = 'SELECT * FROM product;';
    // executing our sqlQuery
    final result = await sqlClient.execute(sqlQuery);
    // a list to save our users from the table -
    // i mean whatever as many as user we get from table

    final products = <ProductModel>[];
    for (final row in result.rows) {
      products.add(ProductModel.fromRowAssoc(row.assoc()));
    }
    // simply returning the whatever the the users
    // we will get from the MySQL database
    return products;
  }

  Future<ProductModel> getProduct({int? id}) async {
    // sqlQuey
    var sqlQuery = 'SELECT * FROM product where id=$id;';
    // executing our sqlQuery
    final result = await sqlClient.execute(sqlQuery);
    // a list to save our users from the table -
    // i mean whatever as many as user we get from table

    final product = ProductModel.fromRowAssoc(result.rows.first.assoc());

    // simply returning the whatever the the users
    // we will get from the MySQL database
    return product;
  }

  // accessing the client
  final MySQLClient sqlClient;
}
