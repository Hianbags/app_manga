import 'package:appmanga/Model/Manga_Model/reading_history_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    print("Database path: $path"); // Log path
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Creating database...");
    await db.execute('''
      CREATE TABLE readingHistory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mangaId INTEGER,
        title TEXT, 
        image TEXT,
        currentChapterId INTEGER,
        currentChapterTitle TEXT
      )
    ''');
    await db.execute('''
    CREATE TABLE loginTokens(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      token TEXT
    )
    ''');

  }
  Future<void> insertToken(String token) async {
    Database db = await database;
    await db.insert(
      'loginTokens',
      {'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getToken() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('loginTokens');
    if (maps.isNotEmpty) {
      return maps.first['token'];
    }
    return null;
  }

  Future<void> deleteToken() async {
    Database db = await database;
    await db.delete('loginTokens');
  }
  Future<int> insertReadingHistory(ReadingHistory readingHistory) async {
    Database db = await database;
    return await db.insert('readingHistory', {
      'mangaId': readingHistory.mangaId,
      'title': readingHistory.title,
      'image': readingHistory.image,
      'currentChapterId': readingHistory.currentChapter.id,
      'currentChapterTitle': readingHistory.currentChapter.title,
    });
  }
  Future<List<ReadingHistory>> getReadingHistoryList() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('readingHistory');
    return List.generate(maps.length, (i) {
      return ReadingHistory(
        id: maps[i]['id'],
        mangaId: maps[i]['mangaId'],
        title: maps[i]['title'],
        image: maps[i]['image'],
        currentChapter: ChapterReadingHistory(
          id: maps[i]['currentChapterId'],
          title: maps[i]['currentChapterTitle'],
        ),
      );
    });
  }
  Future<int> updateReadingHistory(ReadingHistory readingHistory) async {
    Database db = await database;
    return await db.update(
      'readingHistory',
      {
        'mangaId': readingHistory.mangaId,
        'title': readingHistory.title,
        'image': readingHistory.image,
        'currentChapterId': readingHistory.currentChapter.id,
        'currentChapterTitle': readingHistory.currentChapter.title,
      },
      where: 'id = ?', // Sử dụng điều kiện where
      whereArgs: [readingHistory.id], // Đảm bảo id không null
    );
  }
  Future<int> deleteReadingHistory(int id) async {
    Database db = await database;
    return await db.delete(
      'readingHistory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> saveReadingHistory(ReadingHistory readingHistory) async {
    final existingHistories = await getReadingHistoryList();
    ReadingHistory? existingHistory;

    try {
      existingHistory = existingHistories.firstWhere(
            (history) => history.mangaId == readingHistory.mangaId,
      );
    } catch (e) {
      existingHistory = null;
    }

    if (existingHistory == null) {
      await insertReadingHistory(readingHistory);
    } else {
      // Update history with the existing history id
      ReadingHistory updatedHistory = ReadingHistory(
        id: existingHistory.id, // Set id from existing history
        mangaId: readingHistory.mangaId,
        title: readingHistory.title,
        image: readingHistory.image,
        currentChapter: readingHistory.currentChapter,
      );
      await updateReadingHistory(updatedHistory);
    }
  }
  Future<ReadingHistory?> getReadingHistoryForManga(int mangaId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'readingHistory',
      where: 'mangaId = ?',
      whereArgs: [mangaId],
    );

    if (maps.isNotEmpty) {
      return ReadingHistory(
        id: maps.first['id'],
        mangaId: maps.first['mangaId'],
        title: maps.first['title'],
        image: maps.first['image'],
        currentChapter: ChapterReadingHistory(
          id: maps.first['currentChapterId'],
          title: maps.first['currentChapterTitle'],
        ),
      );
    }
    return null;
  }
  Future<List<ReadingHistory>> getLimitedReadingHistoryList(int limit) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'readingHistory',
      limit: limit,
    );
    return List.generate(maps.length, (i) {
      return ReadingHistory(
        id: maps[i]['id'],
        mangaId: maps[i]['mangaId'],
        title: maps[i]['title'],
        image: maps[i]['image'],
        currentChapter: ChapterReadingHistory(
          id: maps[i]['currentChapterId'],
          title: maps[i]['currentChapterTitle'],
        ),
      );
    });
  }

}
