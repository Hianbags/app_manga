class BannerModel {
  final int id;
  final String image;
  final String title;
  final String description;
  final List<Category> categories;
  final String rating;
  final int views;

  BannerModel({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.categories,
    required this.rating,
    required this.views,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      categories: List<Category>.from(
          json['categories'].map((category) => Category.fromJson(category))),
      rating: json['rating'],
      views: json['views'],
    );
  }
}

class Category {
  final int id;
  final String title;

  Category({
    required this.id,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
    );
  }
}
