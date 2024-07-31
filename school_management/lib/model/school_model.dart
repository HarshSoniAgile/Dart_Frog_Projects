class SchoolModel {
  SchoolModel({
    this.id,
    this.name,
    this.email,
    this.address,
    this.city,
    this.state,
    this.contry,
    this.zipcode,
    this.photo,
    this.password,
    this.token,
  });

  int? id;
  String? name;
  String? email;
  String? address;
  String? photo;
  int? zipcode;
  String? city;
  String? state;
  String? contry;
  String? password;
  String? token;

  // fromJSON
  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: int.tryParse(json['id'].toString()) as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      photo: json['photo'] as String?,
      zipcode: int.tryParse(json['zipcode'].toString()) as int?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      contry: json['contry'] as String?,
      password: json['password'] as String?,
    );
  }

  // Create an DatabaseModel given a row.assoc() map
  factory SchoolModel.fromRowAssoc(Map<String, String?> json) {
    return SchoolModel(
      id: json['id'] as int?,
      name: json['name'],
      email: json['email'],
      address: json['address'],
      photo: json['photo'],
      zipcode: json['zipcode'] as int?,
      city: json['city'],
      state: json['state'],
      contry: json['contry'],
      password: json['password'],
    );
  }

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toString(),
      'email': email.toString(),
      'address': address.toString(),
      'photo': photo.toString(),
      'zipcode': zipcode,
      'city': city.toString(),
      'state': state.toString(),
      'contry': contry.toString(),
      'token': token.toString(),
    };
  }
}
