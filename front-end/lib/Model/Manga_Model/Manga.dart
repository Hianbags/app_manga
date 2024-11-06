class Manga {
  final int id;
  final String image;
  final String title;
  final String rating;
  final int views;
  final Chapter? chapter;

  Manga({
    required this.id,
    required this.image,
    required this.title,
    required this.rating,
    required this.views,
    required this.chapter
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      rating: json['rating'],
      views: json['views'],
      chapter: json['chapter'] != null ? Chapter.fromJson(json['chapter']) : null, // Handle null chapter
    );
  }
}

class Chapter {
  final String title;
  final String timeDiff;

  Chapter(
      {
        required this.title,
        required this.timeDiff
      })
  ;
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      title: json['title'],
      timeDiff: json['time_diff'],
    );
  }
}
