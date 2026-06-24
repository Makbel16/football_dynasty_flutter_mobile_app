import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'football_dynasty.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE game_saves (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        saveName TEXT NOT NULL,
        gameData TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isCloud INTEGER DEFAULT 0,
        clubName TEXT,
        season INTEGER,
        week INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE user_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE facilities (
        clubId TEXT NOT NULL,
        type TEXT NOT NULL,
        level INTEGER DEFAULT 1,
        maxLevel INTEGER DEFAULT 5,
        PRIMARY KEY (clubId, type)
      )
    ''');

    await db.execute('''
      CREATE TABLE training_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clubId TEXT NOT NULL,
        season INTEGER NOT NULL,
        week INTEGER NOT NULL,
        type TEXT NOT NULL,
        intensity INTEGER DEFAULT 50
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> saveGame({
    required String id,
    required String userId,
    required String saveName,
    required Map<String, dynamic> gameData,
    bool isCloud = false,
    String? clubName,
    int? season,
    int? week,
  }) async {
    final db = await database;
    await db.insert(
      'game_saves',
      {
        'id': id,
        'userId': userId,
        'saveName': saveName,
        'gameData': jsonEncode(gameData),
        'updatedAt': DateTime.now().toIso8601String(),
        'isCloud': isCloud ? 1 : 0,
        'clubName': clubName,
        'season': season,
        'week': week,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> loadGame(String id) async {
    final db = await database;
    final results = await db.query(
      'game_saves',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return jsonDecode(results.first['gameData'] as String) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getSavesForUser(String userId) async {
    final db = await database;
    return db.query(
      'game_saves',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'updatedAt DESC',
    );
  }

  Future<void> deleteSave(String id) async {
    final db = await database;
    await db.delete('game_saves', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final results = await db.query(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return results.first['value'] as String;
  }

  Future<void> saveFacility(String clubId, String type, int level, int maxLevel) async {
    final db = await database;
    await db.insert(
      'facilities',
      {
        'clubId': clubId,
        'type': type,
        'level': level,
        'maxLevel': maxLevel,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFacilities(String clubId) async {
    final db = await database;
    return db.query('facilities', where: 'clubId = ?', whereArgs: [clubId]);
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('game_saves');
    await db.delete('facilities');
    await db.delete('training_sessions');
  }
}
