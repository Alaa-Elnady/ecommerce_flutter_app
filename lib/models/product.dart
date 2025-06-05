class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String? description;
  final double? discount;
  final int? stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.description,
    this.discount,
    this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      description: json['description'],
      discount: (json['discount'] as num?)?.toDouble(),
      stock: json['stock'] as int?,
    );
  }
}
