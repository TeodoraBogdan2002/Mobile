import 'package:exam/models/fitness_data.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _name = 'activityapp.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _name);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE activity_data (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          date TEXT NOT NULL,
          details TEXT NOT NULL,
          status TEXT NOT NULL,
          participants INTEGER NOT NULL,
          type TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE types (
          id INTEGER PRIMARY KEY,
          type TEXT NOT NULL
        )
      ''');
    });
  }

  static Future<List<ActivityData>> getActivities() async {
    final db = await _getDB();
    final result = await db.query('activity_data');
    return result.map((e) => ActivityData.fromJson(e)).toList();
  }


  // get all dates
  static Future<List<String>> getTypes() async {
    final db = await _getDB();
    final result = await db.query('types');
    logger.log(Level.info, "getTypes() result: $result");
    return result.map((e) => e['type'] as String).toList();
  }

  // get all fitness data by date
  static Future<List<ActivityData>> getActivityDataByType(String type) async {
    final db = await _getDB();
    final result =
        await db.query('activity_data', where: 'type = ?', whereArgs: [type]);
    logger.log(Level.info, "getActivityDataByType() result: $result");
    return result.map((e) => ActivityData.fromJson(e)).toList();
  }

  // add fitness data
  static Future<ActivityData> addActivityData(ActivityData fitnessData) async {
    final db = await _getDB();
    final id = await db.insert('activity_data', fitnessData.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addActivityData() id: $id");
    return fitnessData.copy(id: id);
  }

  static Future<ActivityData> getActivityDataById(int id) async {
    final db = await _getDB();
    final result = await db.query('activity_data', where: 'id = ?', whereArgs: [id]);

      // If the result is not empty, return the first element
      return ActivityData.fromJson(result.first);
    
  }

  // delete fitness data
  static Future<int> deleteActivityData(int id) async {
    final db = await _getDB();
    final result =
        await db.delete('activity_data', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "deleteActivityData() result: $result");
    return result;
  }

  static Future<void> updateActivityData( List<ActivityData> eventData) async {
    final db = await _getDB();
    
    for (var data in eventData) {
      await db.insert('activity_data', data.toJsonWithoutId());
    }
    logger.log(
        Level.info, "updateActivityData() activityData: $eventData");
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

  // // update fintess data for date
  // static Future<void> updateMealDataForType(
  //     String date, List<ActivityData> fitnessData) async {
  //   final db = await _getDB();
  //   await db.delete('meal_data', where: 'type = ?', whereArgs: [date]);
  //   for (var data in fitnessData) {
  //     await db.insert('meal_data', data.toJsonWithoutId());
  //   }
  //   logger.log(
  //       Level.info, "updateMealDataForType() mealData: $fitnessData");
  // }

  // close database
  static Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
