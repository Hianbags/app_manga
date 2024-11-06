import 'package:flutter/material.dart';
import 'package:appmanga/Model/Manga_Model/Manga.dart';
import 'package:appmanga/Service/Manga_Service/Manga_Service.dart';

class MangaListPage extends StatefulWidget {
  @override
  _MangaListPageState createState() => _MangaListPageState();
}

class _MangaListPageState extends State<MangaListPage> {
  final MangaService _mangaService = MangaService();
  List<Manga> _mangaList = [];
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMangaList();
  }

  // Fetch manga list and update the state
  Future<void> _fetchMangaList() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final mangaList = await _mangaService.getMangaList(page: _currentPage, useCache: false);
      setState(() {
        _mangaList.addAll(mangaList);
        _currentPage++;
      });
    } catch (error) {
      // Handle error and provide user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load manga: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle scroll notifications to implement infinite scroll
  bool _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoading) {
      _fetchMangaList();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manga mới cập nhật'),
        backgroundColor: Colors.grey[500],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: ListView.builder(
          itemCount: _mangaList.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _mangaList.length) {
              return Center(child: CircularProgressIndicator());
            }

            final manga = _mangaList[index];
            return MangaCard(manga: manga);
          },
        ),
      ),
    );
  }
}

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
