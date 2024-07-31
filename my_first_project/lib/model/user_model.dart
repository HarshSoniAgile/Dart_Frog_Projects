class DatabaseModel {
  const DatabaseModel({
    this.email,
    this.password,
  });

  // fromJSON
  factory DatabaseModel.fromJson(Map<String, dynamic> json) {
    return DatabaseModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  // Create an DatabaseModel given a row.assoc() map
  factory DatabaseModel.fromRowAssoc(Map<String, String?> json) {
    return DatabaseModel(
      email: json['email'],
      password: json['password'],
    );
  }

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'email': email.toString(),
      'password': password.toString(),
    };
  }

  final String? email;
  final String? password;
}
