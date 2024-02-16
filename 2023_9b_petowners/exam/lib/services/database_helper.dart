import 'package:exam/models/fitness_data.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _name = 'petapp.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _name);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE pet_data (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          breed TEXT NOT NULL,
          age INTEGER NOT NULL,
          weight INTEGER NOT NULL,
          owner TEXT NOT NULL,
          location TEXT NOT NULL,
          description TEXT NOT NULL
        )
      ''');
      
    });
  }

  static Future<List<PetData>> getPets() async {
    final db = await _getDB();
    final result = await db.query('pet_data');
    return result.map((e) => PetData.fromJson(e)).toList();
  }

  // get all fitness data by date
  static Future<PetData> getPetDataById(int id) async {
    final db = await _getDB();
    final result = await db.query('pet_data', where: 'id = ?', whereArgs: [id]);

      // If the result is not empty, return the first element
      return PetData.fromJson(result.first);
    
  }

  // add fitness data
  static Future<PetData> addPetData(PetData fitnessData) async {
    final db = await _getDB();
    final id = await db.insert('pet_data', fitnessData.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addPetData() id: $id");
    return fitnessData.copy(id: id);
  }

  // delete fitness data
  static Future<int> deletePetData(int id) async {
    final db = await _getDB();
    final result =
        await db.delete('pet_data', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "deletePetData() result: $result");
    return result;
  }

  static Future<void> updatePetData( List<PetData> eventData) async {
    final db = await _getDB();
    
    for (var data in eventData) {
      await db.insert('pet_data', data.toJsonWithoutId());
    }
    logger.log(
        Level.info, "updatePetData() petData: $eventData");
  }

  // // update fintess data for date
  // static Future<void> updateMealDataForType(
  //     String date, List<PetData> fitnessData) async {
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
