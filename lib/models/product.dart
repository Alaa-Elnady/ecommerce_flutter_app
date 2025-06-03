class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double discount;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.discount,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"].toString(),
      name: json["title"] ?? "",
      category: json["category"] ?? "Uncategorized",
      description: json["description"] ?? "",
      price:
          (json["price"] is int ? json["price"].toDouble() : json["price"]) ??
          0,
      discount:
          (json["discount"] is int
              ? json["discount"].toDouble()
              : json["discount"]) ??
          0,
      image: json["image"] ?? 0,
    );
  }
}
