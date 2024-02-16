import 'package:exam/models/fitness_data.dart';
import 'package:exam/models/user_data.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _name = 'nutritionapp.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _name);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE meal_data (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          type TEXT NOT NULL,
          calories INTEGER NOT NULL,
          date TEXT NOT NULL,
          notes TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE types (
          id INTEGER PRIMARY KEY,
          type TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE user (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL, 
          age INTEGER NOT NULL,
          height INTEGER NOT NULL
        )
      ''');
    });
  }

  static Future<List<MealData>> getMeals() async {
    final db = await _getDB();
    final result = await db.query('meal_data');
    return result.map((e) => MealData.fromJson(e)).toList();
  }

  static Future<List<UserData>> getUsers() async {
    final db = await _getDB();
    final result = await db.query('user');
    return result.map((e) => UserData.fromJson(e)).toList();
  }

  // get all dates
  static Future<List<String>> getTypes() async {
    final db = await _getDB();
    final result = await db.query('types');
    logger.log(Level.info, "getTypes() result: $result");
    return result.map((e) => e['type'] as String).toList();
  }

  // get all fitness data by date
  static Future<List<MealData>> getMealDataByType(String type) async {
    final db = await _getDB();
    final result =
        await db.query('meal_data', where: 'type = ?', whereArgs: [type]);
    logger.log(Level.info, "getMealDataByType() result: $result");
    return result.map((e) => MealData.fromJson(e)).toList();
  }

  // add fitness data
  static Future<MealData> addMealData(MealData fitnessData) async {
    final db = await _getDB();
    final id = await db.insert('meal_data', fitnessData.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addMealData() id: $id");
    return fitnessData.copy(id: id);
  }

  static Future<UserData> addUserData(UserData fitnessData) async {
    final db = await _getDB();
    final id = await db.insert('user', fitnessData.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addUserData() id: $id");
    return fitnessData.copy(id: id);
  }

  // delete fitness data
  static Future<int> deleteMealData(int id) async {
    final db = await _getDB();
    final result =
        await db.delete('meal_data', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "deleteMealData() result: $result");
    return result;
  }

  static Future<void> updateMealData( List<MealData> eventData) async {
    final db = await _getDB();
    
    for (var data in eventData) {
      await db.insert('meal_data', data.toJsonWithoutId());
    }
    logger.log(
        Level.info, "updateMealData() mealData: $eventData");
  }

  //update dates in database
  static Future<void> updateTypes(List<String> dates) async {
    final db = await _getDB();
    await db.delete('types');
    for (var date in dates) {
      await db.insert('types', {'type': date});
    }
    logger.log(Level.info, "updateTypes() types: $dates");
  }

  // update fintess data for date
  static Future<void> updateMealDataForType(
      String date, List<MealData> fitnessData) async {
    final db = await _getDB();
    await db.delete('meal_data', where: 'type = ?', whereArgs: [date]);
    for (var data in fitnessData) {
      await db.insert('meal_data', data.toJsonWithoutId());
    }
    logger.log(
        Level.info, "updateMealDataForType() mealData: $fitnessData");
  }

  // close database
  static Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
