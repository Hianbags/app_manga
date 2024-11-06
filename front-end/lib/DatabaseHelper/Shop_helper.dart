import 'package:appmanga/Model/Shop_Model/product_detail_model.dart';
import 'package:appmanga/Model/Shop_Model/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:appmanga/Model/Shop_Model/category_model.dart';

class DatabaseCategoryHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'products.db');

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
    );
  }

  static Future<void> insertCategory(Category category) async {
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
  }

  static Future<bool> categoryExists(int categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'categories',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return result.isNotEmpty;
  }

  static Future<void> incrementViewCount(int categoryId) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE categories SET view_count = view_count + 1 WHERE category_id = ?',
      [categoryId],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  static Future<void> addViewedCategories(List<Category> categories) async {
    for (var category in categories) {
      bool exists = await categoryExists(category.id);
      if (exists) {
        await incrementViewCount(category.id);
      } else {
        await insertCategory(category);
      }
    }
  }
  static Future<List<int>> getTopThreeCategoryIds() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT category_id FROM categories
      ORDER BY view_count DESC
      LIMIT 3
    ''');
    return result.map((row) => row['category_id'] as int).toList();
  }
}
