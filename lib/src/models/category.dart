class Category {
  final int id;
  final String name;
  final String slug;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['ID'],
      name: json['name'],
      slug: json['slug'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image_url': imageUrl,
    };
  }
}