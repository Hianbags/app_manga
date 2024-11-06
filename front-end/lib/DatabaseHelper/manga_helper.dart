import 'package:appmanga/Model/Manga_Model/manga_detail_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseMangaCategoryHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mangas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY,
            title TEXT,
            category_id INTEGER,
            view_count INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Handle database upgrade logic here
        // For example:
        // if (oldVersion < 2) {
        //   await db.execute('ALTER TABLE categories ADD COLUMN new_column TEXT');
        // }
      },
    );
  }

  static Future<void> insertCategory(Category category) async {
    try {
      final db = await database;
      await db.insert(
        'categories',
        {
          'id': category.id,
          'title': category.title,
          'category_id': category.id,
          'view_count': 1,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Handle insertion error
      print('Error inserting category: $e');
    }
  }

  static Future<bool> categoryExists(int categoryId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'categories',
        where: 'category_id = ?',
        whereArgs: [categoryId],
      );
      return result.isNotEmpty;
    } catch (e) {
      // Handle query error
      print('Error checking category existence: $e');
      return false;
    }
  }

  static Future<void> incrementViewCount(int categoryId) async {
    try {
      final db = await database;
      await db.rawUpdate(
        'UPDATE categories SET view_count = view_count + 1 WHERE category_id = ?',
        [categoryId],
      );
    } catch (e) {
      // Handle update error
      print('Error incrementing view count: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final db = await database;
      return await db.query('categories');
    } catch (e) {
      // Handle query error
      print('Error fetching all categories: $e');
      return [];
    }
  }

  static Future<void> addViewedCategories(List<Category> categories) async {
    for (var category in categories) {
      try {
        bool exists = await categoryExists(category.id);
        if (exists) {
          await incrementViewCount(category.id);
        } else {
          await insertCategory(category);
        }
      } catch (e) {
        // Handle error for each category
        print('Error processing category ${category.id}: $e');
      }
    }
  }

  static Future<List<int>> getTopThreeCategoryIds() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT category_id FROM categories
        ORDER BY view_count DESC
        LIMIT 3
      ''');
      return result.map((row) => row['category_id'] as int).toList();
    } catch (e) {
      // Handle query error
      print('Error fetching top categories: $e');
      return [];
    }
  }
}
