class StudentModel {
  int? id;
  String? name;
  String? parentNumber;
  String? address;
  String? photo;
  String? dob;
  int? std;
  int? schoolID;

  StudentModel({
    this.id,
    this.name,
    this.parentNumber,
    this.photo,
    this.address,
    this.dob,
    this.schoolID,
    this.std,
  });

  // fromJSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: int.tryParse(json['id'].toString()) as int?,
      name: json['name'] as String?,
      parentNumber: json['parent_number'] as String?,
      address: json['address'] as String?,
      photo: json['photo'] as String?,
      std: int.tryParse(json['std'].toString()) as int?,
      dob: json['dob'] as String?,
      schoolID: int.tryParse(json['school_id'].toString()) as int?,
    );
  }

  // Create an DatabaseModel given a row.assoc() map
  factory StudentModel.fromRowAssoc(Map<String, String?> json) {
    return StudentModel(
      id: int.tryParse(json['id'].toString()) as int?,
      name: json['name'] as String?,
      parentNumber: json['parent_number'] as String?,
      address: json['address'] as String?,
      photo: json['photo'] as String?,
      std: int.tryParse(json['std'].toString()) as int?,
      dob: json['dob'] as String?,
      schoolID: int.tryParse(json['school_id'].toString()) as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toString(),
      'parent_number': parentNumber.toString(),
      'address': address.toString(),
      'photo': photo.toString(),
      'dob': dob.toString(),
      'std': std,
      'school_id': schoolID,
    };
  }
}
