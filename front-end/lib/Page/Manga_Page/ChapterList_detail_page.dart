import 'package:appmanga/Model/Manga_Model/manga_detail_model.dart';
import 'package:appmanga/Page/Manga_Page/page_page.dart';
import 'package:appmanga/init/format.dart';
import 'package:flutter/material.dart';

class ChapterList extends StatefulWidget {
  final MangaDetail mangaDetail;

  ChapterList({required this.mangaDetail});

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  bool _isSortedByNewest = true;

  List<Chapter> get sortedChapters {
    List<Chapter> sortedList = List.from(widget.mangaDetail.chapters);
    sortedList.sort((a, b) => _isSortedByNewest ? b.id.compareTo(a.id) : a.id.compareTo(b.id));
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Chapter",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSortedByNewest = true;
                      });
                    },
                    child: Text(
                      "Mới nhất",
                      style: TextStyle(
                        fontWeight: _isSortedByNewest ? FontWeight.bold : FontWeight.normal,
                        color: _isSortedByNewest ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSortedByNewest = false;
                      });
                    },
                    child: Text(
                      "Cũ nhất",
                      style: TextStyle(
                        fontWeight: !_isSortedByNewest ? FontWeight.bold : FontWeight.normal,
                        color: !_isSortedByNewest ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: sortedChapters.length,
          itemBuilder: (context, index) {
            return ChapterTile(
              chapter: sortedChapters[index],
              mangaDetail: widget.mangaDetail,
              totalChapters: sortedChapters.length,
              sortedChapters: sortedChapters,
            );
          },
        ),
      ],
    );
  }
}

class ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final MangaDetail mangaDetail;
  final int totalChapters;
  final List<Chapter> sortedChapters;

  ChapterTile({
    required this.chapter,
    required this.mangaDetail,
    required this.totalChapters,
    required this.sortedChapters,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChapterPage(
              mangaDetail: mangaDetail,
              chapterId: chapter.id,
              currentChapter: sortedChapters.indexOf(chapter) + 1,
              totalChapters: totalChapters,
              chapters: sortedChapters,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(chapter.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatChapterTitle(chapter.title),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      chapter.createdAt,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

