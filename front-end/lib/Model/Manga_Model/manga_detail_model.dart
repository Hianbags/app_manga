class MangaDetail {
  final int id;
  final String title;
  final String image;
  final String author;
  final String description;
  final String status;
  final String rating;
  final bool favorite;
  final int views;
  final String updatedAt;
  final List<Category> categories;
  final List<Chapter> chapters;

  MangaDetail({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.description,
    required this.status,
    required this.rating,
    required this.favorite,
    required this.views,
    required this.updatedAt,
    required this.categories,
    required this.chapters,
  });

  factory MangaDetail.fromJson(Map<String, dynamic> json) {
    return MangaDetail(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      author: json['author'],
      description: json['description'],
      status: json['status'],
      rating: json['rating'],
      favorite: json['favorite'],
      views: json['views'],
      updatedAt: json['updated_at'],
      categories: List<Category>.from(json['categories'].map((x) => Category.fromJson(x))),
      chapters: List<Chapter>.from(json['chapters'].map((x) => Chapter.fromJson(x))),
    );
  }
}

class Chapter {
  final int id;
  final String title;
  final String createdAt;
  final String image;

  Chapter({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.image,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      createdAt: json['time_diff'],
      image: json['image'],
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
