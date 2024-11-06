import 'package:flutter/material.dart';
import 'package:appmanga/Model/Manga_Model/Manga.dart';

class MangaCard extends StatelessWidget {
  final Manga manga;

  MangaCard({required this.manga});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: Image.network(
                manga.image,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manga.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Đánh giá: ${manga.rating}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Views: ${manga.views}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    if (manga.chapter != null) ...[
                      Text(
                        formatChapterTitle(manga.chapter!.title),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Cập nhật lần cuối: ${manga.chapter!.timeDiff} trước',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Format chapter title by extracting the last number in the title
String formatChapterTitle(String title) {
  RegExp regex = RegExp(r'\d+$');
  Match? match = regex.firstMatch(title);

  if (match != null) {
    String lastNumber = match.group(0)!;
    return "Chương " + lastNumber;
  } else {
    return title;
  }
}
