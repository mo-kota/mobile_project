class FavoriteItem {
  final int productId;
  final String title;
  final double price;
  final String image;

  FavoriteItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'createdAt': DateTime.now(),
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      productId: (map['productId'] as num).toInt(),
      title: map['title'] ?? '',
      price: (map['price'] as num).toDouble(),
      image: map['image'] ?? '',
    );
  }
}