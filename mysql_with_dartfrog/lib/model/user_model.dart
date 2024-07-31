class UserModel {
  const UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  });

  // fromJSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  // Create an DatabaseModel given a row.assoc() map
  factory UserModel.fromRowAssoc(Map<String, String?> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password'],
    );
  }

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'first_name': firstName.toString(),
      'last_name': lastName.toString(),
      'email': email.toString(),
      'password': password.toString(),
    };
  }

  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? password;
}
