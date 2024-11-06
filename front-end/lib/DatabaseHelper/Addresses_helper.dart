import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await _getDatabasePath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await _createDatabaseFromSQL(db);
      },
    );
  }

  Future<String> _getDatabasePath() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'address_helper.db');
    return path;
  }

  Future<void> _createDatabaseFromSQL(Database db) async {
    String sql = await rootBundle.loadString('assets/database/db.sql');
    List<String> sqlStatements = sql.split(';');

    for (String statement in sqlStatements) {
      statement = statement.trim();
      if (statement.isNotEmpty && _isExecutableStatement(statement)) {
        try {
          await db.execute(statement);
        } catch (e) {
          print('Error executing statement: $statement');
          print(e);
        }
      }
    }
  }

  bool _isExecutableStatement(String statement) {
    List<String> nonExecutableStatements = ['PRAGMA', 'BEGIN', 'COMMIT', '--', 'ROLLBACK'];
    for (String nonExecutable in nonExecutableStatements) {
      if (statement.startsWith(nonExecutable)) {
        return false;
      }
    }
    return true;
  }

  Future<List<Map<String, dynamic>>> getProvinces() async {
    final db = await database;
    return await db.query('provinces');
  }
  // thành phố
  Future<List<Map<String, dynamic>>> getDistrictsByProvinceCode(String provinceCode) async {
    final db = await database;
    return await db.query(
      'districts',
      where: 'province_code = ?',
      whereArgs: [provinceCode],
    );
  }
  //quận
  Future<List<Map<String, dynamic>>> getWardsByDistrictCode(String Ward) async {
    final db = await database;
    return await db.query(
      'wards',
      where: 'district_code = ?',
      whereArgs: [Ward],
    );
  }
}
