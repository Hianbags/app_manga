import 'package:appmanga/DatabaseHelper/manga_helper.dart';
import 'package:flutter/material.dart';
import 'package:appmanga/Model/Manga_Model/Manga.dart';
import 'package:appmanga/Service/Manga_Service/Manga_Service.dart';

class MangaListSuggesPage extends StatefulWidget {
  @override
  _MangaListSuggesPageState createState() => _MangaListSuggesPageState();
}

class _MangaListSuggesPageState extends State<MangaListSuggesPage> {
  final MangaCategoryService _mangaService = MangaCategoryService();
  final ScrollController _scrollController = ScrollController();
  List<Manga> _mangaList = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchMangaList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMoreData) {
        _fetchMangaList();
      }
    });
  }

  Future<void> _fetchMangaList() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<int> topCategoryIds = await DatabaseMangaCategoryHelper.getTopThreeCategoryIds();
      final mangaList = await _mangaService.getMangasByCategoryIds(topCategoryIds, _currentPage);

      setState(() {
        if (mangaList.isEmpty) {
          _hasMoreData = false;
        } else {
          _mangaList.addAll(mangaList);
          _currentPage++;
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load manga: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manga mới cập nhật'),
        backgroundColor: Colors.grey[500],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _mangaList.length,
              itemBuilder: (context, index) {
                final manga = _mangaList[index];
                return MangaCard(manga: manga);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
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
