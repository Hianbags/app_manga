class SearchManga {
  final int id;
  final String image;
  final String title;
  final String? chapterTitle; // Nullable String

  SearchManga({
    required this.id,
    required this.image,
    required this.title,
    this.chapterTitle,
  });

  factory SearchManga.fromJson(Map<String, dynamic> json) {
    return SearchManga(
      id: json['id'] as int,
      image: json['image'] as String,
      title: json['title'] as String,
      chapterTitle: json['chapters']?['title'] as String?, // Handle possible null value
    );
  }
}
