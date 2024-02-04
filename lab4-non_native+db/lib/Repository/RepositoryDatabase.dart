// import 'dart:ffi';
import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:homework2/Repository/DatabaseConnection.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../Story.dart';

class DatabaseRepo {
  static const _dbName = "foodstories.db";
  static const _dbVersion = 1;
  static const _table = "story";

  //singleton pattern
  DatabaseRepo._();

  static final DatabaseRepo dbInstance = DatabaseRepo._();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $_table
        (_id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        products TEXT NOT NULL,
        calories INTEGER NOT NULL,
        sugar INTEGER NOT NULL,
        text TEXT NOT NULL)''');
  }

  Future<List<FoodStory>> getStories() async {
    Database db = await dbInstance.database;

    var stories = await db.query(_table);

    List<FoodStory> storyList = stories.isNotEmpty
      ? stories.map((s) => FoodStory.fromMap(s)).toList()
        : [];

    return storyList;
  }

  Future<int> add(FoodStory story) async {
    Database db = await dbInstance.database;

    return await db.insert(_table, story.toMap());
  }

  Future<int> removeFromList(int id) async {
    Database db = await dbInstance.database;
    return await db.delete(_table, where: '_id = ?', whereArgs: [id]);
  }

  Future<int> update(FoodStory story) async {
    Database db = await dbInstance.database;
    return await db.update(_table, story.toMap(), where: '_id = ?', whereArgs: [story.id]);
  }

}