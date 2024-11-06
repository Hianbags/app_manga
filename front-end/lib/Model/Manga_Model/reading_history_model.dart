class ChapterReadingHistory {
  final int id;
  final String title;

  ChapterReadingHistory({required this.id, required this.title});

  factory ChapterReadingHistory.fromMap(Map<String, dynamic> json) => ChapterReadingHistory(
    id: json['chapterId'],
    title: json['chapterTitle'],
  );

  Map<String, dynamic> toMap() => {
    'chapterId': id,
    'chapterTitle': title,
  };
}

class ReadingHistory {
  final int? id;
  final int mangaId;
  final String title;
  final String image;
  final ChapterReadingHistory currentChapter;

  ReadingHistory({this.id, required this.mangaId, required this.title, required this.image, required this.currentChapter});

  factory ReadingHistory.fromMap(Map<String, dynamic> json) => ReadingHistory(
    id: json['id'],
    mangaId: json['mangaId'],
    title: json['title'],
    image: json['image'],
    currentChapter: ChapterReadingHistory.fromMap(json),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'mangaId': mangaId,
    'title': title,
    'image': image,
    'chapterId': currentChapter.id,
    'chapterTitle': currentChapter.title,
  };
}
