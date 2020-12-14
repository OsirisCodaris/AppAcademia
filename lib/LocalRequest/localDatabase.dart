import 'dart:io';
import 'package:academia/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = "academiaprod.db";
  static final _dbVersion = 2;
  static final _tableUser = 'user';

  static final columID = "id";
  static final columFullname = "fullname";
  static final columPhone = "phone";
  static final columEmail = "email";
  static final columModule = "module";
  static final columRole = "role";
  static final columToken = "token";
  static final columRefreshToken = "refreshToken";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $_tableUser( 
      $columID INTEGER PRIMARY KEY,
      $columFullname TEXT NOT NULL,
      $columPhone TEXT NOT NULL,
      $columEmail TEXT NOT NULL,
      $columModule INTEGER NOT NULL,
      $columRole TEXT NOT NULL,
      $columToken TEXT NOT NULL,
      $columRefreshToken TEXT NOT NULL )
      
      ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.database;

    return await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> user() async {
    Database db = await instance.database;
    return await db.query(_tableUser);
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db.update(_tableUser, user.toMap(),
        where: '$columID = ?', whereArgs: [user.idusers]);
  }

  Future<int> deleteUser() async {
    Database db = await instance.database;

    return await db.delete(_tableUser);
  }
}
