import 'package:appmanga/Page/Manga_Page/manga_list_update_page.dart';
import 'package:appmanga/Service/Manga_Service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:appmanga/Model/Manga_Model/Manga.dart';
import 'package:appmanga/Model/Manga_Model/category_model.dart';

class MangaListByCategoryPage extends StatefulWidget {
  final CategoryManga category;

  MangaListByCategoryPage({required this.category});

  @override
  _MangaListByCategoryPageState createState() => _MangaListByCategoryPageState();
}

class _MangaListByCategoryPageState extends State<MangaListByCategoryPage> {
  final CategoryService _categoryService = CategoryService();
  List<Manga> _mangaList = [];
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMangaList();
  }

  // Fetch manga list by category and update the state
  Future<void> _fetchMangaList() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final mangaList = await _categoryService.getMangaListByCategory(widget.category.id, _currentPage);
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
        title: Text('Manga: ${widget.category.title}'),
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
