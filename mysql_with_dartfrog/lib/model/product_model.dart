class ProductModel {
  int? id;
  String? name;
  String? description;
  String? origin;
  String? photos;
  String? price;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.origin,
    this.photos,
    this.price,
  });

  // Create an DatabaseModel given a row.assoc() map
  factory ProductModel.fromRowAssoc(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse(json['id']),
      name: json['name'],
      description: json['description'],
      origin: json['origin'],
      photos: json['photo'],
      price: json['price'],
    );
  }

  // fromJSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] != null ? int.tryParse(json['id']) : null,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      origin: json['origin'] ?? "",
      photos: json['photo'] ?? "",
      price: json['price'] ?? "",
    );
  }

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toString(),
      'description': description.toString(),
      'origin': origin.toString(),
      'photo': photos.toString(),
      'price': price.toString(),
    };
  }
}
