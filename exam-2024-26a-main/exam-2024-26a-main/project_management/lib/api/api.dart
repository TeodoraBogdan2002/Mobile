import 'package:dio/dio.dart';
import 'package:project_management/models/project.dart';
import 'package:logger/logger.dart';

const String baseUrl = 'http://10.0.2.2:2426';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<ProjectData>> getProjects() async {
    logger.log(Level.info, "getProjects() called");
    final response = await dio.get('$baseUrl/projects');
    logger.log(Level.info, "getProjects() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => ProjectData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error, "getProjects() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<ProjectData> addProjectData(ProjectData fitnessData) async {
    logger.log(Level.info, "addProjectData() called");
    final response =
        await dio.post('$baseUrl/project', data: fitnessData.toJsonWithoutId());
    logger.log(Level.info, "addProjectData() response: $response");
    if (response.statusCode == 200) {
      return ProjectData.fromJson(response.data);
    } else {
      logger.log(
          Level.error, "addProjectData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<List<ProjectData>> getInProgressProjects() async {
    logger.log(Level.info, "getInProgressProjects() called");
    final response = await dio.get('$baseUrl/projects');
    logger.log(Level.info, "getInProgressProjects() response: $response");
    if (response.statusCode == 200) {
      final List<ProjectData> allProjects = (response.data as List)
          .map((e) => ProjectData.fromJson(e))
          .toList();
      // Filter projects with status "in progress"
      final List<ProjectData> inProgressProjects =
          allProjects.where((project) => project.status == "in progress").toList();

      return inProgressProjects;
    } else {
      logger.log(Level.error, "getInProgressProjects() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }
}
