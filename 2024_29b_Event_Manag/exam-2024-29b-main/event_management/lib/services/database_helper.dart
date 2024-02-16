import 'package:event_management/models/project.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _name = 'eventmanagement.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _name);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE event_data (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          organizer TEXT NOT NULL,
          category TEXT NOT NULL,
          capacity INTEGER NOT NULL,
          registered INTEGER NOT NULL
        )
      ''');
      
    });
  }

  // get all project data by name
  static Future<List<EventData>> getEventDataByName(String name) async {
    final db = await _getDB();
    final result =
        await db.query('event_data', where: 'name = ?', whereArgs: [name]);
    logger.log(Level.info, "getEventDataByName() result: $result");
    return result.map((e) => EventData.fromJson(e)).toList();
  }

  //get all project management entities
  static Future<List<EventData>> getEvents() async {
    final db = await _getDB();
    final result = await db.query('event_data');
    return result.map((e) => EventData.fromJson(e)).toList();
  }

  // add fitness data
  static Future<EventData> addEventData(EventData eventData) async {
    final db = await _getDB();
    final id = await db.insert('event_data', eventData.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addEventData() id: $id");
    return eventData.copy(id: id);
  }

  // delete fitness data
  static Future<int> deleteEventData(int id) async {
    final db = await _getDB();
    final result =
        await db.delete('event_data', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "deleteEventData() result: $result");
    return result;
  }

  // update fintess data for date
  static Future<void> updateEventData( List<EventData> eventData) async {
    final db = await _getDB();
    
    for (var data in eventData) {
      await db.insert('event_data', data.toJsonWithoutId());
    }
    logger.log(
        Level.info, "updateEventData() eventData: $eventData");
  }


  // close database
  static Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
