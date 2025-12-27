class CartItem {
  final int productId;
  final String title;
  final double price;
  final String image;
  final int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'updatedAt': DateTime.now(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: (map['productId'] as num).toInt(),
      title: map['title'] ?? '',
      price: (map['price'] as num).toDouble(),
      image: map['image'] ?? '',
      quantity: (map['quantity'] as num).toInt(),
    );
  }
}