import 'package:appmanga/Model/Manga_Model/Search_model.dart';
import 'package:appmanga/Service/Manga_Service/Manga_Service.dart';
import 'package:flutter/foundation.dart';

class MangaProvider with ChangeNotifier {
  List<SearchManga> _mangas = [];
  bool _isLoading = false;

  List<SearchManga> get mangas => _mangas;
  bool get isLoading => _isLoading;

  final SearchMangaService _SearchMangaService = SearchMangaService();

  void searchManga(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _mangas = (await _SearchMangaService.searchManga(query));
    } catch (e) {
      _mangas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}