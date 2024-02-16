import 'package:task_management/models/task_management_data.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _name = 'taskmanag.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _name);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE task_data (
          id INTEGER PRIMARY KEY,
          date TEXT NOT NULL,
          type TEXT NOT NULL,
          duration DOUBLE NOT NULL,
          priority TEXT NOT NULL,
          category TEXT NOT NULL,
          description TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE taskDays (
          id INTEGER PRIMARY KEY,
          date TEXT NOT NULL
        )
      ''');
    });
  }

  // get all recorded task days
  static Future<List<String>> getDates() async {
    final db = await _getDB();
    final result = await db.query('taskDays');
    logger.log(Level.info, "getDates() result: $result");
    return result.map((e) => e['date'] as String).toList();
  }

  // get all tasks data by date
  static Future<List<TaskManagementData>> getTaskDataByDate(String date) async {
    final db = await _getDB();
    final result =
        await db.query('task_data', where: 'date = ?', whereArgs: [date]);
    logger.log(Level.info, "getTaskDataByDate() result: $result");
    return result.map((e) => TaskManagementData.fromJson(e)).toList();
  }

  // add task management data
  static Future<TaskManagementData> addTaskData(TaskManagementData taskData) async {
    final db = await _getDB();
    final id = await db.insert('task_data', taskData.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addTaskData() id: $id");
    return taskData.copy(id: id);
  }

  // delete task data
  static Future<int> deleteTaskData(int id) async {
    final db = await _getDB();
    final result =
        await db.delete('task_data', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "deleteTaskData() result: $result");
    return result;
  }

  //update dates in database
  static Future<void> updateDates(List<String> taskDays) async {
    final db = await _getDB();
    await db.delete('taskDays');
    for (var date in taskDays) {
      await db.insert('taskDays', {'date': date});
    }
    logger.log(Level.info, "updateDates() taskDays: $taskDays");
  }

  // update fintess data for date
  static Future<void> updateTMDataForDate(
      String date, List<TaskManagementData> taskmanagData) async {
    final db = await _getDB();
    await db.delete('task_data', where: 'date = ?', whereArgs: [date]);
    for (var data in taskmanagData) {
      await db.insert('task_data', data.toJsonWithoutId());
    }
    logger.log(
        Level.info, "updateTMDataForDate() taskmanagData: $taskmanagData");
  }

  // close database
  static Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
