import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:map_pro/model/user_model.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._privateConstructor();
  static LocalDatabase get instance => _instance;

  static Database? _database;

  LocalDatabase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 3, // ⬅️ Bump version to ensure _onUpgrade runs
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT NOT NULL,
        mobile TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        countryData TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE session(
        key TEXT PRIMARY KEY,
        value INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN countryData TEXT NOT NULL DEFAULT ""');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS session(
          key TEXT PRIMARY KEY,
          value INTEGER
        )
      ''');
    }
  }

  Future<int> insertUserModel(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<UserModel?> getUserModelByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  Future<UserModel?> getUserModelById(int? id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }




  Future<void> saveSessionValue(String key, int value) async {
    final db = await database;
    await db.insert(
      'session',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int?> getSessionValue(String key) async {
    final db = await database;
    final result = await db.query(
      'session',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (result.isNotEmpty) {
      return result.first['value'] as int;
    }
    return null;
  }


  Future<void> removeSessionKey(String key) async {
    print("jkhjhjkhkjhjkh");
    final db = await database;
    await db.delete(
      'session',
      where: 'key = ?',
      whereArgs: [key],
    );
  }
}
