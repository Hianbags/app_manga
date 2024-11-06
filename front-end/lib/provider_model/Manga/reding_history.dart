import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:appmanga/Model/Manga_Model/reading_history_model.dart';

class ReadingHistoryNotifier extends ChangeNotifier {
  ReadingHistory? _readingHistory;

  ReadingHistory? get readingHistory => _readingHistory;

  void updateReadingHistory(ReadingHistory? newHistory) {
    _readingHistory = newHistory;
    notifyListeners();
  }
}

class ReadingHistoryListNotifier extends ChangeNotifier {
  List<ReadingHistory> _readingHistoryList = [];

  List<ReadingHistory> get readingHistoryList => _readingHistoryList;

  Future<void> loadReadingHistory() async {
    _readingHistoryList = await DatabaseHelper().getReadingHistoryList();
    notifyListeners();
  }
  Future<void> addReadingHistory(ReadingHistory readingHistory) async {
    await DatabaseHelper().saveReadingHistory(readingHistory);
    await loadReadingHistory();
  }
  Future<void> deleteReadingHistory(int id) async {
    await DatabaseHelper().deleteReadingHistory(id);
    await loadReadingHistory();
  }
}


