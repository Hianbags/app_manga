class CategoryManga {
  final int id;
  final String title;

  CategoryManga({
    required this.id,
    required this.title,
  });

  factory CategoryManga.fromJson(Map<String, dynamic> json) {
    return CategoryManga(
      id: json['id'],
      title: json['title'],
    );
  }

}
