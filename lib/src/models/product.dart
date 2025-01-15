class Product {
  final int id;
  final String name;
  final String slug;
  final String imageUrl;
  final String description;
  final double price;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ID'],
      name: json['name'],
      slug: json['slug'],
      imageUrl: json['image'],
      description: json['description'],
      price: json['price'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image_url': imageUrl,
      'description': description,
      'price': price,
      'category_id': categoryId,
    };
  }
}