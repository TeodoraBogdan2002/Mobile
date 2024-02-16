import 'package:project_management/models/project.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _name = 'projectmanagement.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _name);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE project_data (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          team TEXT NOT NULL,
          details TEXT NOT NULL,
          status TEXT NOT NULL,
          members INTEGER NOT NULL,
          type TEXT NOT NULL
        )
      ''');
      
    });
  }

  // get all project data by name
  static Future<List<ProjectData>> getProjectDataByName(String name) async {
    final db = await _getDB();
    final result =
        await db.query('project_data', where: 'name = ?', whereArgs: [name]);
    logger.log(Level.info, "getProjectDataByName() result: $result");
    return result.map((e) => ProjectData.fromJson(e)).toList();
  }

  //get all project management entities
  static Future<List<ProjectData>> getProjects() async {
    final db = await _getDB();
    final result = await db.query('project_data');
    return result.map((e) => ProjectData.fromJson(e)).toList();
  }

  // add fitness data
  static Future<ProjectData> addProjectData(ProjectData projectData) async {
    final db = await _getDB();
    final id = await db.insert('project_data', projectData.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addProjectData() id: $id");
    return projectData.copy(id: id);
  }

  // delete fitness data
  static Future<int> deleteProjectData(int id) async {
    final db = await _getDB();
    final result =
        await db.delete('project_data', where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "deleteProjectData() result: $result");
    return result;
  }

  // update fintess data for date
  static Future<void> updateProjectData( List<ProjectData> fitnessData) async {
    final db = await _getDB();
    
    for (var data in fitnessData) {
      await db.insert('project_data', data.toJsonWithoutId());
    }
    logger.log(
        Level.info, "updateProjectData() fitnessData: $fitnessData");
  }


  // close database
  static Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
