class CartItem {
  final String productId;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final double discount;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    this.discount = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'discount': discount,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
      quantity: json['quantity'],
      discount: (json['discount'] ?? 0.0).toDouble(),
    );
  }

  CartItem copyWith({
    String? productId,
    String? name,
    double? price,
    String? image,
    int? quantity,
    double? discount,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
    );
  }
}
