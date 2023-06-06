class Product {
  final String? id;
  final String title;
  final String brand;
  final String category;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String? thumbnail;

  Product({
    this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.thumbnail
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "brand": brand,
      "category": category,
      "description": description,
      "price": price,
      "discountPercentage": discountPercentage,
      "rating": rating,
      "stock": stock,
      "thumbnail": thumbnail
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return Product(
      id: map["_id"], // for the other database from Render
      // id: map["id"], // for the database from Firebase
      title: map["title"],
      brand: map["brand"],
      category: map["category"],
      description: map["description"],
      price: map["price"].toDouble() ?? 0,
      discountPercentage: map["discountPercentage"].toDouble() ?? 0,
      rating: map["rating"].toDouble() ?? 0,
      stock: map["stock"] ?? 0,
      thumbnail: map["thumbnail"]
    );
  }

  @override
  String toString() {
    return "Product(title: $title brand: $brand category: $category price: $price)";
  }
}