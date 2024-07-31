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

  // fromJSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      origin: json['origin'],
      photos: json['photo'],
      price: json['price'],
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
