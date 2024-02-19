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
        CREATE TABLE vehicle_data (
          id INTEGER PRIMARY KEY,
          model TEXT NOT NULL,
          status TEXT NOT NULL,
          capacity INTEGER NOT NULL,
          owner TEXT NOT NULL,
          manufacturer TEXT NOT NULL,
          cargo INTEGER NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE manufacturers (
          id INTEGER PRIMARY KEY,
          manufacturer TEXT NOT NULL
        )
      ''');
    });
  }

  static Future<List<VehicleData>> getVehicles() async {
    final db = await _getDB();
    final result = await db.query('vehicle_data');
    return result.map((e) => VehicleData.fromJson(e)).toList();
  }


  // get all dates
  static Future<List<String>> getManufacturers() async {
    final db = await _getDB();
    final result = await db.query('manufacturers');
    logger.log(Level.info, "getManufacturers() result: $result");
    return result.map((e) => e['manufacturer'] as String).toList();
  }

  // get all fitness data by date
  static Future<List<VehicleData>> getVehicleDataByManufacturer(String manufacturer) async {
    final db = await _getDB();
    final result =
        await db.query('vehicle_data', where: 'manufacturer = ?', whereArgs: [manufacturer]);
    logger.log(Level.info, "getVehicleDataByManufacturer() result: $result");
    return result.map((e) => VehicleData.fromJson(e)).toList();
  }

  // add fitness data
  static Future<VehicleData> addVehicleData(VehicleData carData) async {
    final db = await _getDB();
    final id = await db.insert('vehicle_data', carData.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addVehicleData() id: $id");
    return carData.copy(id: id);
  }

  static Future<VehicleData> getCarDataById(int id) async {
    final db = await _getDB();
    final result = await db.query('vehicle_data', where: 'id = ?', whereArgs: [id]);

      // If the result is not empty, return the first element
      return VehicleData.fromJson(result.first);
    
  }

  // delete fitness data
  static Future<int> deleteCarData(int id) async {
    final db = await _getDB();
    final result =
        await db.delete('vehicle_data', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "deleteCarData() result: $result");
    return result;
  }

  static Future<void> updateCarData( List<VehicleData> eventData) async {
    final db = await _getDB();
    
    for (var data in eventData) {
      await db.insert('vehicle_data', data.toJsonWithoutId());
    }
    logger.log(
        Level.info, "updateCarData() activityData: $eventData");
  }

  //update dates in database
  static Future<void> updateManufacturers(List<String> dates) async {
    final db = await _getDB();
    await db.delete('manufacturers');
    for (var date in dates) {
      await db.insert('manufacturers', {'manufacturer': date});
    }
    logger.log(Level.info, "updateManufacturers() manufacturers: $dates");
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
